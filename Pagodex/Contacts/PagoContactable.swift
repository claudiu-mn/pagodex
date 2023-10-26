//
//  PagoContactable.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

protocol PagoContactable {
    
    var id: Int { get }
    var firstName: String { get }
    var lastName: String { get }
    var email: String? { get }
    var phoneNumber: String? { get }
    
}
