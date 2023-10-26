//
//  RemoteContact.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

struct RemoteContact: PagoContactable {
    
    let id: Int
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    
    init(id: Int,
         firstName: String,
         lastName: String,
         email: String? = nil,
         phoneNumber: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
}
