//
//  ExpandibleCell.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//

import UIKit

class ExpandibleCell: UITableViewCell {
    static let identifier: String = "ExpandibleCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    func configure(with model: ExpandableCellModel) {
        textLabel?.text = model.title
    }
    
    private func setupViews() {
        
    }
}
