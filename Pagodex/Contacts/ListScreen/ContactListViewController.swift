//
//  ContactListViewController.swift
//  Pagodex
//
//  Created by Claudiu Miron on 09.10.2023.
//

import UIKit

protocol ContactListViewControllerDelegate: AnyObject {
    func contactListViewController(_ contactListViewController: ContactListViewController,
                                   didSelectContact contact: Contact)
    
    func didWantNewContact(in contactListViewController: ContactListViewController)
}

private enum RemoteImageState {
    case loading
    case success (UIImage)
    case error
}

class ContactListViewController: UIViewController {
    
    public weak var delegate: ContactListViewControllerDelegate?
    
    private let imageRepo: CachingPhotoRepository = CachingPhotoRepository(remoteContactImageSource: PicsumPhotos())
    
    private var contacts: [Contact] = []
    
    private var remoteImages: [Int: RemoteImageState] = [:]
    
    private weak var contactListView: ContactListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacte" // TODO: Add i18n
        
        setUpContactListView()
        
        fetchData()
    }
    
    private func setUpContactListView() {
        let contactListView = ContactListView()
        
        contactListView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contactListView)
        
        contactListView
            .leadingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            .isActive = true
        contactListView
            .trailingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            .isActive = true
        contactListView
            .topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        // TODO: Is bottom padding automatically added to the table view to
        //       account for safe area? Seems it does on iOS 16.4 sim (iPhone 13).
        //       Wasn't expecting that; investigate.
        contactListView
            .bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        
        contactListView.backgroundColor = Colors.backgroundSecondary
        
        contactListView.dataSource = self
        contactListView.delegate = self
        
        self.contactListView = contactListView
    }
    
    private func fetchData() {
        let goRestTransformer: ([GoRestContact]) -> [RemoteContact] = { goRestContacts in
            return goRestContacts.filter { goRestContact in
                // TODO: Ask about values for status (<lower/upper/etc>case)
                return goRestContact.status == "active"
            }.map { goRestContact in
                return RemoteContact(id: goRestContact.id,
                                     email: goRestContact.email)
            }
        }
        let source = GoRestContactList(listTransformer: goRestTransformer)
        
        let remoteContactMapper: (RemoteContact) -> Contact = { remote in
            return Contact(id: remote.id, email: remote.email)
        }
        let repo =
            CachingContactListRepository(remoteContactListSource: source,
                                         remoteContactMapper: remoteContactMapper)
        Task.init {
            let contactList = try await repo.getList()
            contacts = contactList
            contactListView.reloadData()
        }
    }
    
}

extension ContactListViewController: ContactListViewDataSource {
    
    internal func numberOfitemsInContactListView(_ contactListView: ContactListView) -> Int {
        return contacts.count
    }
    
    internal func contactListView(_ contactListView: ContactListView,
                                  contactAtRow row: Int) -> SimpleContact {
        let contact = contacts[row]
        let id = contact.id
        
        var image: UIImage?
        
        if !contact.id.isMultiple(of: 2) {
            // TODO: `0.isMultiple(of: 2) == true` Do we want that?
            
            let imageState = remoteImages[id]
            
            switch imageState {
            case .none:
                remoteImages[id] = .loading
                Task.init {
                    let image = try? await imageRepo.getImage(id)
                    if let image = image {
                        remoteImages[id] = .success(image)
                    } else {
                        remoteImages[id] = .error
                    }
                    contactListView.reload(row: row)
                }
                break
                
            case .loading:
                break
                
            case .success(let img):
                image = img
                break
                
            case .error:
                break
            }
        }
        
        return SimpleContact(name: contact.email, image: image)
    }
    
}

extension ContactListViewController: ContactListViewDelegate {
    
    func contactListView(_ contactListView: ContactListView,
                         didSelectContactAtRow row: Int) {
        delegate?.contactListViewController(self, didSelectContact: contacts[row])
    }
    
}
