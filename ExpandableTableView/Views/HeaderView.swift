//
//  HeaderView.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//

import UIKit

class HeaderView: UIView {
    var titleText: String? {
        didSet {
            label.text = titleText
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 28),
            label.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
