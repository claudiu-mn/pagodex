//
//  ContactsModule.swift
//  Pagodex
//
//  Created by Claudiu Miron on 24.10.2023.
//

import UIKit

class ContactsModule {
    
    private(set) var rootViewController: UINavigationController
    
    private var listViewController: ContactListViewController
    
    init() {
        listViewController = ContactListViewController()
        rootViewController = UINavigationController(rootViewController: listViewController)
        
        listViewController.delegate = self
    }
    
}

extension ContactsModule: ContactListViewControllerDelegate {
    
    func contactListViewController(_ contactListViewController: ContactListViewController,
                                   didSelectContact contact: Contact) {
        let newViewController = UIViewController()
        newViewController.title = "Adaugă contact"
        newViewController.view.backgroundColor = .white
        
        rootViewController.pushViewController(newViewController,
                                              animated: true)
        
        debugPrint("Selected \(contact)")
    }
    
    func didWantNewContact(in contactListViewController: ContactListViewController) {
        debugPrint("Should add a new contact at some point...")
    }
    
}
