//
//  ContactListViewPresenting.swift
//  Pagodex
//
//  Created by Claudiu Miron on 26.10.2023.
//

protocol ContactListViewPresentingDelegate: AnyObject {
    
    func presenter(_ presenter: ContactListViewPresenting,
                   didSelectContact contact: Contact)
    
}

protocol ContactListViewPresenting: AnyObject {
    
    func start()
    
    func set(view: ContactListViewing)
    
    // TODO: Seems kinda weird.
    func set(delegate: ContactListViewPresentingDelegate?)
    
    func getContactCount() -> Int
    
    func get(personAt row: Int) -> Person
    
    func didSelectContact(at row: Int)
    
    func retry()
    
}
