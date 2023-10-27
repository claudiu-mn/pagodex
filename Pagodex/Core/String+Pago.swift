//
//  String+Pago.swift
//  Pagodex
//
//  Created by Claudiu Miron on 26.10.2023.
//

import Foundation

extension String {
    
    /// Stolen with some shame from https://stackoverflow.com/a/51371892
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        
        guard let components = formatter.personNameComponents(from: self) else {
          return ""
        }

        return components.allInitials
    }
    
    // TODO: Thoroughly test this
    var strippedOfWhitespace: String {
        return replacingOccurrences(of: "\\s",
                                    with: "",
                                    options: .regularExpression)
    }
    
}
