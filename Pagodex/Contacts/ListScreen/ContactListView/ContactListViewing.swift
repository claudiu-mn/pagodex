//
//  ContactListViewing.swift
//  Pagodex
//
//  Created by Claudiu Miron on 26.10.2023.
//

enum ContactListViewingState {
    
    case loading
    case success
    case failure(String)
    
}

protocol ContactListViewing: AnyObject {
    
    func set(state: ContactListViewingState)
    
    func reload(row: Int)
    
}
