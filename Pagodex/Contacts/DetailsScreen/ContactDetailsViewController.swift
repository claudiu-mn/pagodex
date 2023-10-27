//
//  ContactDetailsViewController.swift
//  Pagodex
//
//  Created by Claudiu Miron on 25.10.2023.
//

import UIKit

protocol ContactDetailsViewControllerDelegate: AnyObject {
    
    func didFinish()
    
}

class ContactDetailsViewController: UIViewController {
    
    public weak var delegate: ContactDetailsViewControllerDelegate?
    
    private var contact: Contact?
    
    private weak var scrollView: UIScrollView!
    
    private weak var firstNameField: PagoTextField!
    private weak var lastNameField: PagoTextField!
    private weak var phoneNumberField: PagoTextField!
    private weak var emailField: PagoTextField!
    
    private weak var bottomConstraint: NSLayoutConstraint!
    
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
    
    init(contact: Contact?) {
        super.init(nibName: nil, bundle: nil)
        
        self.contact = contact
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonItem = UIBarButtonItem()
        // TODO: Add i18n
        barButtonItem.title = contact == nil ? "Adaugă" : "Salvează"
        barButtonItem.target = self
        barButtonItem.action = #selector(onRightBarButtonTapped)
        barButtonItem.tintColor = Colors.button
        
        navigationItem.rightBarButtonItem = barButtonItem
        // TODO: Add i18n
        navigationItem.title = contact == nil ? "Adaugă contact" : "Modifică contact"
        
        view.backgroundColor = Colors.backgroundSecondary
        
        setUp()
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector:  #selector(animateWithKeyboard(notification:)),
//                                               name: UIResponder.keyboardWillChangeFrameNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector:  #selector(decideConstraint(notification:)),
//                                               name: UIResponder.keyboardWillShowNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector:  #selector(decideConstraint(notification:)),
//                                               name: UIResponder.keyboardWillHideNotification,
//                                               object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // TODO: Do better
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        var size = scrollView.contentSize
//        size.height = max(scrollView.frame.height, size.height)
//
//        scrollView.contentSize = size
//    }
    
    @objc private func onRightBarButtonTapped() {
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        
        let lacksFirstName = firstName?.strippedOfWhitespace.isEmpty ?? true
        let lacksLastName = lastName?.strippedOfWhitespace.isEmpty ?? true
        
        if lacksFirstName || lacksLastName {
            var message = ""
            
            if lacksFirstName {
                message += "• prenume"
            }
            
            if lacksLastName {
                message += "\n• nume"
            }
            
            let alert = UIAlertController(title: "Informații lipsă:",
                                          message: message,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Am înțeles",
                                          style: .default))
            
            present(alert, animated: true)
            
            return
        }
        
        let email = emailField.text
        let phoneNumber = phoneNumberField.text
        
        let info = ContactInfo(firstName: firstName!,
                               lastName: lastName!,
                               email: email,
                               phoneNumber: phoneNumber)
        
        let manager = Services.shared.resolve(type: ContactsManager.self)
        
        Task.init {
            if let contact = self.contact {
                await manager.updateContact(withId: contact.id, info: info)
            } else {
                await manager.addContact(info: info)
            }
        }
        
        delegate?.didFinish()
    }
    
    private func setUp() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.scrollView = scrollView

        let spacing = Dimensions.standardSpacing

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: spacing,
                                                                     leading: spacing,
                                                                     bottom: spacing,
                                                                     trailing: spacing)
        
        let firstName = PagoTextField()
        firstName.title = "PRENUME"
        firstName.text = contact?.firstName
        firstName.keyboardType = .namePhonePad
        firstNameField = firstName
        
        let lastName = PagoTextField()
        lastName.title = "NUME"
        lastName.text = contact?.lastName
        lastName.keyboardType = .namePhonePad
        lastNameField = lastName
        
        let phoneNumber = PagoTextField()
        phoneNumber.title = "TELEFON"
        phoneNumber.text = contact?.phoneNumber
        phoneNumber.keyboardType = .namePhonePad
        phoneNumberField = phoneNumber

        let email = PagoTextField()
        email.title = "EMAIL"
        email.text = contact?.email
        email.keyboardType = .emailAddress
        emailField = email
        
        let labels = [firstName, lastName, phoneNumber, email]
        
        for label in labels {
            label.delegate = self
            stackView.addArrangedSubview(label)
        }
        
        scrollView.addSubview(stackView)
        
        let layoutGuide = scrollView.contentLayoutGuide
        
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            bottomConstraint,
            stackView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        self.bottomConstraint = bottomConstraint
    }
    
    @objc func decideConstraint(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let moveUp = notification.name == UIResponder.keyboardWillShowNotification
        bottomConstraint.constant = moveUp ? -keyboardFrame.size.height : 0
    }
    
    @objc func animateWithKeyboard(notification: NSNotification) {
        let info = notification.userInfo!
        let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let options = UIView.AnimationOptions(rawValue: curve << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: options) { [weak self] in
            self?.view.setNeedsLayout()
        }
    }
    
}

extension ContactDetailsViewController: PagoTextFieldDelegate {
    
    func didBeginEditing(in pagoTextField: PagoTextField) {
        let frame = pagoTextField.frame
        let size = CGSize(width: frame.width,
                          height: frame.height * Dimensions.standardSpacing)
        // TODO: Doesn't quite do it (check last field)
        scrollView.scrollRectToVisible(CGRect(origin: frame.origin, size: size),
                                       animated: true)
    }
    
    func didEndEditing(in pagoTextField: PagoTextField) {
        switch pagoTextField {
        case firstNameField:
            let _ = lastNameField.becomeFirstResponder()
            break
            
        case lastNameField:
            let _ = phoneNumberField.becomeFirstResponder()
            break
            
        case phoneNumberField:
            let _ = emailField.becomeFirstResponder()
            break

        case emailField:
            let _ = emailField.resignFirstResponder()
            break
            
            
        default:
            fatalError("Unsupported PagoTextField: \(pagoTextField)")
        }
    }
    
}
