//
//  CachingContactListRepository.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

// TODO: Are we sure we want this to be an actor just to shield `list`
//       from multiple simultaneous writes?
actor CachingContactListRepository: ContactListRepository {
    
    private let remoteContactListSource: RemoteContactListSource
    private let remoteContactMapper: (RemoteContact) -> Contact
    
    private var list: [Contact] = []

    init(remoteContactListSource: RemoteContactListSource,
         remoteContactMapper: @escaping (RemoteContact) -> Contact) {
        self.remoteContactListSource = remoteContactListSource
        self.remoteContactMapper = remoteContactMapper
    }
    
    func getList() async throws -> [Contact] {
        let remoteList = try await remoteContactListSource.fetchList()
        
        list.removeAll()
        
        let newList = remoteList.map({ remote in
            return remoteContactMapper(remote)
        })
        
        list.append(contentsOf: newList)
        
        return list
    }
    
    func add(_ contact: Contact) async throws {
        list.append(contact)
    }
    
}
