//
//  GoRestContactList.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

import Foundation

// TODO: I believe this class can be broken down into several parts
class GoRestContactList: RemoteContactListSource {
    
    private let listTransformer: ([GoRestContact]) -> [RemoteContact]
    
    init(listTransformer: @escaping ([GoRestContact]) -> [RemoteContact]) {
        self.listTransformer = listTransformer
    }
    
    func fetchList() async throws -> [RemoteContact] {
        let url = URL(string: "https://gorest.co.in/public/v2/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let goRestContacts = try JSONDecoder().decode([GoRestContact].self,
                                                      from: data)
        
        return listTransformer(goRestContacts)
    }
    
}
