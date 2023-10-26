//
//  PagodexApp.swift
//  Pagodex
//
//  Created by Claudiu Miron on 25.10.2023.
//

class PagodexApp {
    
    private init() { }
    
    public static func start(serviceContainer: ServiceContainerization) {
        let goRestContacts = GoRestContactList { goRestContacts in
            return goRestContacts
                .filter { $0.status == "active" }
                .map {  RemoteContact(id: $0.id, email: $0.email) }
        }
        
        let remoteContactMapper = { (remoteContact: RemoteContact) in
            return Contact(id: remoteContact.id, email: remoteContact.email)
        }
        
        let contactRepo = CachingContactListRepository(remoteContactListSource: goRestContacts,
                                                       remoteContactMapper: remoteContactMapper)
        
        let contactsManager = ContactsManager(contactRepository: contactRepo)
        Task.init { await contactsManager.refreshList() }
        
        let remoteImageSource = PicsumPhotos()
        
        let imageRepository = CachingPhotoRepository(remoteContactImageSource: remoteImageSource)
        
        let contactListPresenter = ContactListViewPresenter(contactsManager: contactsManager,
                                                            imageRepository: imageRepository)
        
        serviceContainer.register(type: ContactListViewPresenting.self,
                                  service: contactListPresenter)
        
        serviceContainer.register(type: ContactsModule.self,
                                  service: ContactsModule())
    }
    
}
