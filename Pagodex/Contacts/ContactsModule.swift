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
    
    internal func contactListViewController(_ contactListViewController: ContactListViewController,
                                            didSelectContact contact: Contact) {
        pushDetailsScreen(contact: contact)
    }
    
    internal func didWantNewContact(in contactListViewController: ContactListViewController) {
        pushDetailsScreen()
    }
    
    private func pushDetailsScreen(contact: Contact? = nil) {
        let detailsVC = ContactDetailsViewController(contact: contact)
        detailsVC.delegate = self
        
        rootViewController.pushViewController(detailsVC, animated: true)
    }
    
}

extension ContactsModule: ContactDetailsViewControllerDelegate {
    
    func didFinish() {
        rootViewController.popViewController(animated: true)
    }
    
}
