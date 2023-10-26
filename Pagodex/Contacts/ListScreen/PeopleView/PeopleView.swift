//
//  PeopleView.swift
//  Pagodex
//
//  Created by Claudiu Miron on 09.10.2023.
//

import UIKit

struct Person {
    
    let name: String
    let image: UIImage?
    
    init(name: String, image: UIImage? = nil) {
        self.name = name
        self.image = image
    }
    
}

protocol PeopleViewDataSource: AnyObject {
    
    func count(in peopleView: PeopleView) -> Int
    func peopleView(_ peopleView: PeopleView, personAtRow row: Int) -> Person
    
}

protocol PeopleViewDelegate: AnyObject {
    
    func peopleView(_ peopleView: PeopleView, didSelectPersonAtRow row: Int)
    
}

// TODO: Consider adding nib/storyboard compatibility
class PeopleView: UIView {
    
    public weak var dataSource: PeopleViewDataSource?
    public weak var delegate: PeopleViewDelegate?
    
    private static let cellId = "PeopleViewCell"
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    init() {
        super.init(frame: .zero)
        
        setUpTableView()
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) is not supported")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        
        tableView.fill(self)
        
        tableView.register(PeopleViewCell.self,
                           forCellReuseIdentifier: PeopleView.cellId)
        
        // TODO: Separator isn't clearly visible
        //       on physical size sim (iPhone 13 / iOS 16.4)
        tableView.separatorInset = .zero
        
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func reloadData() {
        tableView.reloadData()
    }
    
    public func reload(row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)],
                             with: .fade)
    }
    
}

extension PeopleView: UITableViewDelegate {

    internal func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

    internal func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        delegate?.peopleView(self, didSelectPersonAtRow: indexPath.row)
    }

}

extension PeopleView: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        itemCountOrZero()
    }
    
    internal func itemCountOrZero() -> Int {
        dataSource?.count(in: self) ?? 0
    }
    
    internal func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: PeopleView.cellId,
                                          for: indexPath) as! PeopleViewCell
        
        let row = indexPath.row
        let isLastRow = row == itemCountOrZero() - 1
        
        let contact = dataSource?.peopleView(self, personAtRow: row)
        cell.leadingImage = contact?.image
        cell.name = contact?.name ?? ""
        
        if isLastRow {
            cell.separatorInset = UIEdgeInsets(top: 0,
                                               left: .greatestFiniteMagnitude,
                                               bottom: 0,
                                               right: 0)
        }
        
        cell.backgroundColor = Colors.backgroundPrimary
        cell.nameColor = Colors.text
        cell.selectionStyle = .none
        cell.tintColor = Colors.backgroundTertiary
        cell.hasDisclosureIndicator = true
        
        return cell
    }
    
}
