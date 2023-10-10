//
//  ContactListView.swift
//  Pagodex
//
//  Created by Claudiu Miron on 09.10.2023.
//

import UIKit

struct Contact {
    
    let image: UIImage
    let name: String
    let accesoryImage: UIImage
    
}

protocol ContactListViewDataSource: AnyObject {
    
    func numberOfitemsInContactListView(_ contactListView: ContactListView) -> Int
    func contactListView(_ contactListView: ContactListView,
                         contactAtRow row: Int) -> Contact
    
}

protocol ContactListViewDelegate: AnyObject {
    func contactListView(_ contactListView: ContactListView, didSelectContactAtRow row: Int)
}

// TODO: Consider adding nib/storyboard compatibility
class ContactListView: UIView {
    
    override var backgroundColor: UIColor? {
        didSet {
            tableView.backgroundColor = .clear
        }
    }
    
    public weak var dataSource: ContactListViewDataSource?
    public weak var delegate: ContactListViewDelegate?
    
    private static let cellId = "ContactListViewCell"
    
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        
        tableView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .isActive = true
        tableView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .isActive = true
        tableView
            .topAnchor
            .constraint(equalTo: topAnchor)
            .isActive = true
        tableView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .isActive = true
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: ContactListView.cellId)
        
        // TODO: Separator isn't clearly visible
        //       on physical size sim (iPhone 13 / iOS 16.4)
        tableView.separatorInset = .zero
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ContactListView: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        delegate?.contactListView(self, didSelectContactAtRow: indexPath.row)
    }
    
}

extension ContactListView: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        itemCountOrZero()
    }
    
    private func itemCountOrZero() -> Int {
        dataSource?.numberOfitemsInContactListView(self) ?? 0
    }
    
    internal func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: ContactListView.cellId,
                                          for: indexPath)
        
        let row = indexPath.row
        let isLastRow = row == itemCountOrZero() - 1
        
        let contact = dataSource?.contactListView(self, contactAtRow: row)
        
        cell.configureWith(image: contact?.image ?? UIImage.checkmark,
                           accessoryImage: contact?.accesoryImage ?? UIImage(),
                           accessoryColor: Colors.button,
                           text: contact?.name ?? "",
                           backgroundColor: Colors.backgroundPrimary,
                           textColor: Colors.text,
                           hasSeparator: !isLastRow)

        return cell
    }
    
}

extension UITableViewCell {
    
    fileprivate func configureWith(image: UIImage,
                                   accessoryImage: UIImage,
                                   accessoryColor: UIColor,
                                   text: String,
                                   backgroundColor: UIColor,
                                   textColor: UIColor,
                                   hasSeparator: Bool) {
        accessoryView = UIImageView(image: accessoryImage)
        
        // FIXME: Can't change color of disclosure indicator
        tintColor = accessoryColor
        
        var config = defaultContentConfiguration()

        config.text = text
        config.textProperties.color = textColor

        config.image = image

        contentConfiguration = config
        
        if !hasSeparator {
            separatorInset = UIEdgeInsets(top: 0,
                                          left: .greatestFiniteMagnitude,
                                          bottom: 0,
                                          right: 0)
        }
        
        self.backgroundColor = backgroundColor
        
        
        selectionStyle = .none
    }
    
}
