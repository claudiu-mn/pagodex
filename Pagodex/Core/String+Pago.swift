//
//  String+Pago.swift
//  Pagodex
//
//  Created by Claudiu Miron on 26.10.2023.
//

import Foundation

extension String {
    
    /// Stolen shamelessly from https://stackoverflow.com/a/51371892
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        
        guard let components = formatter.personNameComponents(from: self) else {
          return ""
        }

        return components.allInitials
    }
    
    var strippedOfWhitespaces: String {
        return replacingOccurrences(of: "\\s",
                                    with: "",
                                    options: .regularExpression)
    }
    
}
