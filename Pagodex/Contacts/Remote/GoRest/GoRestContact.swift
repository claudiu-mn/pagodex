//
//  GoRestContact.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

struct GoRestContact: Codable, IntIdentifiableContact {
    
    let id: Int
    let name: String
    let email: String
    let status: String
    
}
