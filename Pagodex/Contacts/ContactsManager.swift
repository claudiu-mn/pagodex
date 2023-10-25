//
//  ContactsManager.swift
//  Pagodex
//
//  Created by Claudiu Miron on 24.10.2023.
//

import Combine

class ContactsManager {
    
    enum ContactsError: Error {
        case repoError
    }
    
    @Published private(set) var listState: FetchState<[Contact], ContactsError> = .loading
    
    private var contactRepository: ContactRepository
    
    init(contactRepository: ContactRepository) {
        self.contactRepository = contactRepository
    }
    
    func refreshList() async {
        let list = try? await contactRepository.getList()
        
        if let list = list {
            listState = .success(list)
        } else {
            listState = .failure(.repoError)
        }
    }
    
}
