//
//  ContactRepository.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

protocol ContactRepository {
    
    func getList() async throws -> [Contact]
    func add(_ contact:Contact) async throws
    
}
