//
//  PagodexApp.swift
//  Pagodex
//
//  Created by Claudiu Miron on 25.10.2023.
//

class PagodexApp {
    
    private init() { }
    
    public static func start(serviceContainer: ServiceContainerization) {
        serviceContainer.register(type: ContactsModule.self,
                                  service: ContactsModule())
    }
    
}
