//
//  ViewController.swift
//  Pagodex
//
//  Created by Claudiu Miron on 09.10.2023.
//

import UIKit

class ViewController: UIViewController {
    private let contactListView = ContactListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpContactListView()
    }
    
    private func setUpContactListView() {
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
    }
}

extension ViewController: ContactListViewDataSource {
    internal func numberOfitemsInContactListView(_ contactListView: ContactListView) -> Int {
        return 6
    }
    
    internal func contactListView(_ contactListView: ContactListView,
                                  contactAtRow row: Int) -> Contact {
        return Contact(image: .checkmark,
                       name: "Contact No. \(row)",
                       accesoryImage: UIImage(named: "Chevron")!)
    }
}
