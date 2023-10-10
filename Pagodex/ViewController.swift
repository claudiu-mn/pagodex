//
//  ViewController.swift
//  Pagodex
//
//  Created by Claudiu Miron on 09.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private var contacts: [Contact] = []
    
    private weak var contactListView: ContactListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension ViewController: ContactListViewDataSource {
    
    internal func numberOfitemsInContactListView(_ contactListView: ContactListView) -> Int {
        return contacts.count
    }
    
    internal func contactListView(_ contactListView: ContactListView,
                                  contactAtRow row: Int) -> SimpleContact {
        let contact = contacts[row]
        
        // TODO: Consider drawing the chevron in code
        return SimpleContact(image: .checkmark,
                             name: contact.email,
                             accesoryImage: UIImage(named: "Chevron")!)
    }
    
}

extension ViewController: ContactListViewDelegate {
    
    func contactListView(_ contactListView: ContactListView,
                         didSelectContactAtRow row: Int) {
        debugPrint("Selected contact at \(row)")
    }
    
}
