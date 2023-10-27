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
                .map {  RemoteContact(id: $0.id,
                                      firstName: $0.name,
                                      lastName: "",
                                      email: $0.email)
                }
        }
        
        let remoteContactMapper = { (remoteContact: RemoteContact) in
            return Contact(id: remoteContact.id,
                           firstName: remoteContact.firstName,
                           lastName: remoteContact.lastName,
                           email: remoteContact.email,
                           phoneNumber: remoteContact.phoneNumber)
        }
        
        let contactRepo = SimpleContactRepository(remoteContactListSource: goRestContacts,
                                                  remoteContactMapper: remoteContactMapper)
        
        let contactsManager = ContactsManager(contactRepository: contactRepo)
        serviceContainer.register(type: ContactsManager.self,
                                  service: contactsManager)
        
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
