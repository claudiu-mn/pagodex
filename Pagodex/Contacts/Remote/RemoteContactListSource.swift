//
//  RemoteContactListSource.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

protocol RemoteContactListSource {
    
    func fetchList() async throws -> [RemoteContact]
    
}
