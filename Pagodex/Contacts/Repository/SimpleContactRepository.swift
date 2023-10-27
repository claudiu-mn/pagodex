//
//  SimpleContactRepository.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

import Foundation

// TODO: Are we sure we want this to be an actor just to shield `list`
//       from multiple simultaneous writes?
class SimpleContactRepository: ContactRepository {
    
    private let remoteContactListSource: RemoteContactListSource
    private let remoteContactMapper: (RemoteContact) -> Contact

    init(remoteContactListSource: RemoteContactListSource,
         remoteContactMapper: @escaping (RemoteContact) -> Contact) {
        self.remoteContactListSource = remoteContactListSource
        self.remoteContactMapper = remoteContactMapper
    }
    
    func getList() async throws -> [Contact] {
//        sleep(5)
        
        let remoteList = try await remoteContactListSource.fetchList()
        
        let newList = remoteList.map({ remote in
            return remoteContactMapper(remote)
        })
        
        
        return newList
    }
    
}
