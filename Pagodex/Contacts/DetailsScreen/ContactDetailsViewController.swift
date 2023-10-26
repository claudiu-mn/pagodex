//
//  ContactDetailsViewController.swift
//  Pagodex
//
//  Created by Claudiu Miron on 25.10.2023.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    
    @available(*, unavailable)
    init() {
        fatalError("init() is not supported")
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:, bundle:) is not supported")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    init(name: String?) {
        super.init(nibName: nil, bundle: nil)
        
        title = name ?? "Adaugă contact" // TODO: Add i18n
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundSecondary
    }
    
}
