//
//  ContactListViewPresenter.swift
//  Pagodex
//
//  Created by Claudiu Miron on 26.10.2023.
//

import Combine
import UIKit

class ContactListViewPresenter {
    
    private weak var view: ContactListViewing?
    private weak var delegate: ContactListViewPresentingDelegate?
    
    private let contactsManager: ContactsManager
    private var contactsSubscription: AnyCancellable!
    private var contacts: [Contact] = []

    private let imageRepository: ContactImageRepository
    private var images: [Int: UIImage] = [:]
    private let imageQueue = DispatchQueue(label: "mn.claudiu.imageQueue",
                                           attributes: .concurrent)
    
    init(contactsManager: ContactsManager,
         imageRepository: ContactImageRepository) {
        self.imageRepository = imageRepository
        self.contactsManager = contactsManager
    }
    
    private func set(viewState: ContactListViewingState) {
        Task.init { @MainActor in
            view?.set(state: viewState)
        }
    }
    
    private func fetchImageForContact(at row: Int) async {
        let id = contacts[row].id
        
        let image = try? await imageRepository.getImage(id)
        
        imageQueue.async(flags: .barrier) { [weak self] in
            if let image = image {
                self?.images[row] = image
            } else {
                self?.images[row] = UIImage()
            }
        }
        
        await MainActor.run { view?.reload(row: row) }
    }
    
    private func update(state: ContactsManager.ListState) {
        switch state {
        case .loading:
            set(viewState: .loading)
            break
            
        case .success(let contacts):
            self.contacts = contacts
            set(viewState: .success)
            break
            
        case .failure(_):
            // TODO: Add i18n
            set(viewState: .failure("Something went wrong; tap to try again."))
            break
        }
    }
    
}

extension ContactListViewPresenter: ContactListViewPresenting {
    
    func start() {
        Task.init {
            self.contactsSubscription = await contactsManager
                .$listState
                .sink { [weak self] in self?.update(state: $0) }
        }
    }
    
    func set(view: ContactListViewing) {
        self.view = view
    }
    
    func set(delegate: ContactListViewPresentingDelegate?) {
        self.delegate = delegate
    }
    
    func retry() {
        Task.init {
            images = [:]
            await contactsManager.refreshList()
        }
    }
    
    func getContactCount() -> Int {
        return contacts.count
    }
    
    func get(personAt row: Int) -> Person {
        let contact = contacts[row]
        
        let name = contact.fullName

        guard let cachedImage = images[row] else {
            Task.init { await fetchImageForContact(at: row) }
            return Person(name: name)
        }

        return Person(name: name, image: cachedImage)
    }
    
    func didSelectContact(at row: Int) {
        delegate?.presenter(self, didSelectContact: contacts[row])
    }
    
}
