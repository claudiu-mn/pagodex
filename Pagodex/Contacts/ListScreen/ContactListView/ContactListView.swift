//
//  ContactListView.swift
//  Pagodex
//
//  Created by Claudiu Miron on 26.10.2023.
//

import UIKit

class ContactListView: UIView, ContactListViewing {
    
    private weak var containerView: ContainerView<PeopleView>!
    private weak var presenter: ContactListViewPresenting!
    
    @available(*, unavailable)
    init() {
        fatalError("init is not supported")
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) is not supported")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    init(presenter: ContactListViewPresenting) {
        super.init(frame: .zero)
        
        setUp(presenter: presenter)
    }
    
    private func setUp(presenter: ContactListViewPresenting) {
        self.presenter = presenter
        presenter.set(view: self)
        
        let peopleView = PeopleView()
        peopleView.delegate = self
        peopleView.dataSource = self
        
        let containerView = ContainerView(successView: peopleView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.fill(self)
        self.containerView = containerView
    }
    
    func set(state: ContactListViewingState) {
        switch state {
        case .loading:
            containerView.state = .loading
            break
            
        case .success:
            containerView.successView.reloadData()
            containerView.state = .success
            break
            
        case .failure(let message):
            containerView.state = .failure(message, { [weak self] in
                self?.presenter?.retry()
            })
            break
        }
    }
    
    func reload(row: Int) {
        containerView.successView.reload(row: row)
    }
    
}

extension ContactListView: PeopleViewDelegate {
    
    func peopleView(_ peopleView: PeopleView, didSelectPersonAtRow row: Int) {
        presenter?.didSelectContact(at: row)
    }
    
}

extension ContactListView: PeopleViewDataSource {
    
    func count(in peopleView: PeopleView) -> Int {
        return presenter.getContactCount()
    }
    
    func peopleView(_ peopleView: PeopleView, personAtRow row: Int) -> Person {
        return presenter.get(personAt: row)
    }
    
}
