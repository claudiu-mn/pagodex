//
//  ContactListViewController.swift
//  Pagodex
//
//  Created by Claudiu Miron on 09.10.2023.
//

import Combine
import UIKit

protocol ContactListViewControllerDelegate: AnyObject {
    
    func contactListViewController(_ contactListViewController: ContactListViewController,
                                   didSelectContact contact: Contact)
    
    func didWantNewContact(in contactListViewController: ContactListViewController)
    
}

class ContactListViewController: UIViewController {
    
    public weak var delegate: ContactListViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) is not supported")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(named: "AddContact")
        barButtonItem.style = .plain
        barButtonItem.target = self
        barButtonItem.action = #selector(onRightBarButtonTapped)
        barButtonItem.tintColor = Colors.button
        
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.title = "Contacte" // TODO: Add i18n
        
        view.backgroundColor = Colors.backgroundSecondary
        
        setUpContactListView()
    }
    
    private func setUpContactListView() {
        let presenter = Services.shared.resolve(type: ContactListViewPresenting.self)
        presenter.set(delegate: self)
        presenter.start()
        
        let contactListView = ContactListView(presenter: presenter)
        contactListView.backgroundColor = .clear
        contactListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contactListView)
        contactListView.fill(view)
    }
    
    @objc
    private func onRightBarButtonTapped() {
        delegate?.didWantNewContact(in: self)
    }
    
}

extension ContactListViewController: ContactListViewPresentingDelegate {
    
    func presenter(_ presenter: ContactListViewPresenting,
                   didSelectContact contact: Contact) {
        delegate?.contactListViewController(self, didSelectContact: contact)
    }
    
}
