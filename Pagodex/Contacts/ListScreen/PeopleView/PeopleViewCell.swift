//
//  PeopleViewCell.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

import UIKit

// TODO: I don't like the sloppy layout code in this view
// TODO: Can we flatten the view hierarchy?
class PeopleViewCell: UITableViewCell {
    
    private weak var stackView: UIStackView!
    
    private weak var leadingView: UIView!
    private weak var leadingImageView: UIImageView!
    private weak var initialsLabel: UILabel!
    
    private weak var nameLabel: UILabel!
    private weak var trailingView: UIView!
    
    public var name: String = "" {
        didSet {
            nameLabel.text = name
            
            var initials = name.initials
            if initials.isEmpty {
                initials = "?"
            }
            
            initialsLabel.text = initials
        }
    }
    
    public var nameColor: UIColor {
        get {
            return nameLabel.textColor
        }
        
        set {
            nameLabel.textColor = newValue
        }
    }
    
    public var leadingImage: UIImage? {
        didSet {
            leadingImageView.image = leadingImage
        }
    }
    
    public var hasDisclosureIndicator: Bool = false {
        didSet {
            updateDisclosureIndicatorVisibility(hasDisclosureIndicator)
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            initialsLabel.textColor = backgroundColor
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            leadingView.backgroundColor = tintColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        let spacing = Dimensions.standardSpacing
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        self.stackView = stackView
        stackView.fill(contentView,
                       with: UIEdgeInsets(top: spacing,
                                          left: spacing,
                                          bottom: spacing,
                                          right: spacing))
        
        let leadingView = UIView()
        leadingView.layer.masksToBounds = true
        leadingView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(leadingView)
        stackView.setCustomSpacing(Dimensions.standardSpacing,
                                   after: leadingView)
        leadingView.widthAnchor.constraint(equalTo: leadingView.heightAnchor).isActive = true
        self.leadingView = leadingView
        
        let initialsLabel = UILabel()
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.textAlignment = .center
        leadingView.addSubview(initialsLabel)
        self.initialsLabel = initialsLabel
        
        initialsLabel.fill(leadingView)
        
        let leadingImageView = UIImageView()
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        leadingImageView.contentMode = .scaleToFill
        leadingView.addSubview(leadingImageView)
        self.leadingImageView = leadingImageView
        
        leadingImageView.fill(leadingView)
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.lineBreakMode = .byTruncatingMiddle
        stackView.addArrangedSubview(nameLabel)
        self.nameLabel = nameLabel
        
        let trailingView = UIView()
        trailingView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(trailingView)
        
        trailingView.widthAnchor.constraint(equalToConstant: Dimensions.chevronSize.width).isActive = true
        
        self.trailingView = trailingView
        
        // TODO: Consider drawing in a layer here,
        //       instead of in a dedicated chevron UIView
        let chevron = ChevronView()
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.backgroundColor = .clear
        trailingView.addSubview(chevron)
        
        chevron.centerXAnchor.constraint(equalTo: trailingView.centerXAnchor).isActive = true
        chevron.centerYAnchor.constraint(equalTo: trailingView.centerYAnchor).isActive = true
        chevron.widthAnchor.constraint(equalToConstant: Dimensions.chevronSize.width).isActive = true
        chevron.heightAnchor.constraint(equalToConstant: Dimensions.chevronSize.height).isActive = true
        
        updateDisclosureIndicatorVisibility(hasDisclosureIndicator)
    }
    
    private func updateDisclosureIndicatorVisibility(_ visible: Bool) {
        trailingView.isHidden = !visible
        let spacing = visible ? Dimensions.standardSpacing : 0.0
        stackView.setCustomSpacing(spacing, after: nameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leadingView.layoutIfNeeded()
        leadingView.layer.cornerRadius = leadingView.layer.bounds.width / 2
    }
    
}

/// Stolen shamelessly from https://stackoverflow.com/a/64576199
extension String {
    // TODO: This hasn't been tested/looked at properly
    // TODO: What about multiple spaces?
    var initials: String {
        return self.components(separatedBy: " ")
            .reduce("") {
                ($0.isEmpty ? "" : "\($0.first?.uppercased() ?? "")") +
                ($1.isEmpty ? "" : "\($1.first?.uppercased() ?? "")")
            }
    }
}
