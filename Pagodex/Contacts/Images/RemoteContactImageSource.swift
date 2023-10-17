//
//  RemoteContactImageSource.swift
//  Pagodex
//
//  Created by Claudiu Miron on 17.10.2023.
//

import UIKit

protocol RemoteContactImageSource {
    
    func fetchImage(_ id: Int) async throws -> UIImage
    
}
