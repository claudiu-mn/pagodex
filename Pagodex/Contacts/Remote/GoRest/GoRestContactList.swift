//
//  GoRestContactList.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

import Foundation

// TODO: I believe this class can be broken down into several parts
class GoRestContactList: RemoteContactListSource {
    
    typealias ListTransformer = ([GoRestContact]) -> [RemoteContact]
    
    private let listTransformer: ([GoRestContact]) -> [RemoteContact]
    
    init(listTransformer: @escaping ListTransformer) {
        self.listTransformer = listTransformer
    }
    
    func fetchList() async throws -> [RemoteContact] {
        let url = URL(string: "https://gorest.co.in/public/v2/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let list = try JSONDecoder().decode([GoRestContact].self, from: data)
        
        return listTransformer(list)
    }
    
}
