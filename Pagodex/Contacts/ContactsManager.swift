//
//  ContactsManager.swift
//  Pagodex
//
//  Created by Claudiu Miron on 24.10.2023.
//

import Combine
import Foundation

struct ContactInfo: RealPerson {
    
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    
}

actor ContactsManager {
    
    typealias ListState = FetchState<[Contact], ContactsError>
    
    enum ContactsError: Error {
        case repoError
    }
    
    @Published private(set) var listState: ListState = .loading
    
    private var repoList: [Contact] = []
    private var repoEdits: [Contact] = []
    private var ownList: [Contact] = []
    
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
            repoList = list
            listState = .success(allContacts)
        } else {
            listState = .failure(.repoError)
        }
    }
    
    func updateContact(withId id: Int, info: RealPerson) async {
        listState = .loading
        
//        sleep(5)
        
        let contact = Contact(id: id,
                              firstName: info.firstName,
                              lastName: info.lastName,
                              email: info.email,
                              phoneNumber: info.phoneNumber)
        
        // TODO: Find something more akin to singleWhere
        if let ownIndex = ownList.firstIndex(where: { $0.id == id }) {
            ownList[ownIndex] = contact
        } else {
            ownList.append(contact)
        }
        
        listState = .success(allContacts)
    }
    
    // TODO: Feels dirty because we can't guarantee GoRest gives only positive IDs
    func addContact(info: RealPerson) async {
        listState = .loading
        
//        sleep(5)
        
        let smallestId = ownList.min { $0.id < $1.id }?.id ?? 0
        
        ownList.append(Contact(id: smallestId - 1,
                               firstName: info.firstName,
                               lastName: info.lastName,
                               email: info.email,
                               phoneNumber: info.phoneNumber))
        
        listState = .success(allContacts)
    }
    
    private var allContacts: [Contact] {
        var list = repoList
        
        for own in ownList {
            if let repoIndex = list.firstIndex(where: { $0.id == own.id }) {
                list[repoIndex] = own
            } else {
                list.append(own)
            }
        }
        
        return list
    }
    
}
