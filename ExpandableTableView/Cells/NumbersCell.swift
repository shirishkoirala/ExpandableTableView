//
//  NumbersCell.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//

import UIKit

class NumbersCell: UICollectionViewCell {
    static let identifier: String = "NumbersCell"
    
    var number:String? {
        didSet {
            numberLabel.text = number
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(numberLabel)
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
