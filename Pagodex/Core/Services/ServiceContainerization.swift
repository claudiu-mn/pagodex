//
//  ServiceContainerization.swift
//  Pagodex
//
//  Created by Claudiu Miron on 25.10.2023.
//

// TODO: Perhaps a better name is in order
protocol ServiceContainerization {
    
    func register<Service>(type: Service.Type, service: Service)
    
    func resolve<Service>(type: Service.Type) -> Service
    
}
