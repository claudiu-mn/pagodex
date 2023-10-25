//
//  ContactDetailsViewController.swift
//  Pagodex
//
//  Created by Claudiu Miron on 25.10.2023.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Adaugă contact" // TODO: Add i18n
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundSecondary
    }
    
}
