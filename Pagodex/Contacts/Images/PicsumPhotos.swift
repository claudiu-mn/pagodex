//
//  PicsumPhotos.swift
//  Pagodex
//
//  Created by Claudiu Miron on 17.10.2023.
//

import UIKit

class PicsumPhotos: RemoteContactImageSource {
    
    func fetchImage(_ id: Int) async throws -> UIImage {
        let url = URL(string: "https://picsum.photos/seed/\(id)/200")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return UIImage(data: data)!
    }
    
}
