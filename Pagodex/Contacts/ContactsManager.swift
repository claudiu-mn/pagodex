//
//  ContactsManager.swift
//  Pagodex
//
//  Created by Claudiu Miron on 24.10.2023.
//

import Combine

actor ContactsManager {
    
    typealias ListState = FetchState<[Contact], ContactsError>
    
    enum ContactsError: Error {
        case repoError
    }
    
    @Published private(set) var listState: ListState = .loading
    
    private var contactRepository: ContactRepository
    
    init(contactRepository: ContactRepository) {
        self.contactRepository = contactRepository
        
        Task.init {
            await refreshList()
        }
    }
    
    func refreshList() async {
        listState = .loading
        
        if let list = try? await contactRepository.getList() {
            listState = .success(list)
        } else {
            listState = .failure(.repoError)
        }
    }
    
}
