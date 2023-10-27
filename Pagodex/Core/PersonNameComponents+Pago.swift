//
//  PersonNameComponents+Pago.swift
//  Pagodex
//
//  Created by Claudiu Miron on 26.10.2023.
//

import Foundation

/// Stolen shamelessly from https://stackoverflow.com/a/51371892
extension PersonNameComponents {
    
    // TODO: Think of a better name
    var firstAndLastInitials: String {
        let first = givenName?.first ?? Character(" ")
        let last = familyName?.first ?? Character(" ")
        return "\(first)\(last)".strippedOfWhitespace
    }
    
    // TODO: Think of a better name
    var allInitials: String {
        let first = givenName?.first ?? Character(" ")
        let middle = middleName?.first ?? Character(" ")
        let last = familyName?.first ?? Character(" ")
        return "\(first)\(middle)\(last)".strippedOfWhitespace
    }
    
}
