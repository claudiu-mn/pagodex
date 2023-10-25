//
//  Services.swift
//  Pagodex
//
//  Created by Claudiu Miron on 24.10.2023.
//

final class Services: ServiceContainerization {
    
    static let shared = Services()
    
    private init() {}
    
    private var services: [String: Any] = [:]
    
    func register<Service>(type: Service.Type, service: Service) {
        services["\(type)"] = service
    }
    
    func resolve<Service>(type: Service.Type) -> Service {
        guard let service = services["\(type)"] as? Service else {
            fatalError("No service of type '\(type)' was found? Forgot to register it beforehand?")
        }
        
        return service
    }
}
