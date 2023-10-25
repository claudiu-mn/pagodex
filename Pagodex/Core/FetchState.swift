//
//  FetchState.swift
//  Pagodex
//
//  Created by Claudiu Miron on 24.10.2023.
//

enum FetchState<Success, Failure> {
    case loading
    case success (Success)
    case failure (Failure)
}
