//
//  ExpandView.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//
import UIKit

class ExpandView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        addSubview(expandButton)
        NSLayoutConstraint.activate([
            expandButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 28),
            expandButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            expandButton.topAnchor.constraint(equalTo: self.topAnchor),
            expandButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
