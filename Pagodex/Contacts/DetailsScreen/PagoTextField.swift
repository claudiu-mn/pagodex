//
//  PagoTextField.swift
//  Pagodex
//
//  Created by Claudiu Miron on 26.10.2023.
//

import UIKit

protocol PagoTextFieldDelegate: AnyObject {
    
    func didBeginEditing(in pagoTextField: PagoTextField)
    
    func didEndEditing(in pagoTextField: PagoTextField)
    
}

class PagoTextField: UIControl {
    
    public var keyboardType: UIKeyboardType {
        get { return field.keyboardType }
        set { field.keyboardType = newValue }
    }
    
    public var title: String = "Title" {
        didSet { titleLabel.text = title }
    }
    
    public var text: String? {
        get { return field.text }
        set { field.text = newValue }
    }
    
    public weak var delegate: PagoTextFieldDelegate?
    
    private weak var titleLabel: UILabel!
    private weak var field: UITextField!
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) is not supported")
    }
    
    @available(*, unavailable)
    init(frame: CGRect, primaryAction: UIAction?) {
        fatalError("init(frame:primaryAction:) is not supported")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    init() {
        super.init(frame: .zero)
        
        setUp()
    }
    
    private func setUp() {
        let spacing = Dimensions.smallSpacing
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = Colors.backgroundPrimary
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: spacing,
                                                                     leading: spacing,
                                                                     bottom: spacing,
                                                                     trailing: spacing)
        stackView.layer.cornerRadius = 12
        addSubview(stackView)
        
        stackView.fill(self)
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.label
        stackView.addArrangedSubview(label)
        self.titleLabel = label
        
        let field = UITextField()
        stackView.addArrangedSubview(field)
        self.field = field
        field.textColor = Colors.text
        field.text = text
        field.delegate = self
        
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = Colors.backgroundSecondary
        addSubview(underline)
        
        underline.widthAnchor.constraint(equalTo: field.widthAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underline.topAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
        underline.leadingAnchor.constraint(equalTo: field.leadingAnchor).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: PagoTextField.noIntrinsicMetric, height: 85)
    }
    
    override func resignFirstResponder() -> Bool {
        field.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        field.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
}

extension PagoTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBeginEditing(in: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        endEditing(false)
        delegate?.didEndEditing(in: self)
        return false
    }
    
}
