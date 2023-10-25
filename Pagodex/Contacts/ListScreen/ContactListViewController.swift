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
    
    private weak var peopleView: PeopleView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:, bundle:) is not supported")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "AddContact"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(onRightBarButtonTapped))
        barButtonItem.tintColor = Colors.button
        
        navigationItem.rightBarButtonItem = barButtonItem
        
        title = "Contacte" // TODO: Add i18n
        
        setUpContactListView()
        
        fetchData()
    }
    
    private func setUpContactListView() {
        let peopleView = PeopleView()
        
        peopleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(peopleView)
        
        peopleView
            .leadingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            .isActive = true
        peopleView
            .trailingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            .isActive = true
        peopleView
            .topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        // TODO: Is bottom padding automatically added to the table view to
        //       account for safe area? Seems it does on iOS 16.4 sim (iPhone 13).
        //       Wasn't expecting that; investigate.
        peopleView
            .bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        
        peopleView.backgroundColor = Colors.backgroundSecondary
        
        peopleView.dataSource = self
        peopleView.delegate = self
        
        self.peopleView = peopleView
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
            peopleView.reloadData()
        }
    }
    
    @objc
    private func onRightBarButtonTapped() {
        delegate?.didWantNewContact(in: self)
    }
    
}

extension ContactListViewController: PeopleViewDataSource {
    
    internal func count(in peopleView: PeopleView) -> Int {
        return contacts.count
    }
    
    internal func peopleView(_ peopleView: PeopleView,
                             personAtRow row: Int) -> Person {
        let contact = contacts[row]
        let id = contact.id
        
        var image: UIImage?
        
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
                peopleView.reload(row: row)
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
        
        
        return Person(name: contact.email, image: image)
    }
    
}

extension ContactListViewController: PeopleViewDelegate {
    
    internal func peopleView(_ peopleView: PeopleView,
                             didSelectPersonAtRow row: Int) {
        delegate?.contactListViewController(self,
                                            didSelectContact: contacts[row])
    }
    
}
