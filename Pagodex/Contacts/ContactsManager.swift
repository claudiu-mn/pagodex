//
//  ContactsManager.swift
//  Pagodex
//
//  Created by Claudiu Miron on 24.10.2023.
//

import Combine

actor ContactsManager {
    
    enum ContactsError: Error {
        case repoError
    }
    
    @Published private(set) var listState: FetchState<[Contact], ContactsError> = .loading
    
    private var contactRepository: ContactRepository
    
    init(contactRepository: ContactRepository) {
        self.contactRepository = contactRepository
    }
    
    func refreshList() async {
        if let list = try? await contactRepository.getList() {
            listState = .success(list)
        } else {
            listState = .failure(.repoError)
        }
    }
    
}
