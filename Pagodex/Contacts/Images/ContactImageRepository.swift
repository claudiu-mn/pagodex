//
//  ContactImageRepository.swift
//  Pagodex
//
//  Created by Claudiu Miron on 17.10.2023.
//

import UIKit

protocol ContactImageRepository {
    
    func getImage(_ id: Int) async throws -> UIImage
    
}
