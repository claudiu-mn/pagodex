//
//  Contact.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

struct Contact: PagoContactable {
    
    let id: Int
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    
}

extension Contact {
    
    var fullName: String {
        get {
            let suffix = lastName.strippedOfWhitespace.isEmpty ? "" : " \(lastName)"
            return "\(firstName)\(suffix)"
        }
    }
    
}
