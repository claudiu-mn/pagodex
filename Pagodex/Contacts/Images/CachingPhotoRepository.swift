//
//  CachingPhotoRepository.swift
//  Pagodex
//
//  Created by Claudiu Miron on 17.10.2023.
//

import UIKit

// TODO: Are we sure we want this to be an actor just to shield `cachedImages`
//       from multiple simultaneous writes?
actor CachingPhotoRepository: ContactImageRepository {
    
    private let remoteContactImageSource: RemoteContactImageSource
    
    private var cachedImages: [Int: UIImage] = [:]
    
    init(remoteContactImageSource: RemoteContactImageSource) {
        self.remoteContactImageSource = remoteContactImageSource
    }
    
    func getImage(_ id: Int) async throws -> UIImage {
        if let cached = cachedImages[id] {
            return cached
        }
        
        let image = try await remoteContactImageSource.fetchImage(id)
        
        cachedImages[id] = image

        return image
    }
    
}
