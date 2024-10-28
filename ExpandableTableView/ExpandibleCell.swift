//
//  ExpandibleCell.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//

import UIKit

protocol ExpandibleCellDelegate: AnyObject {
    func expandableTableViewCell(_ tableViewCell: UITableViewCell, expanded: Bool)
}

class ExpandibleCell: UITableViewCell {
    static let identifier: String = "ExpandibleCell"
    
    private var expanded: Bool = false
    
    weak var delegate: ExpandibleCellDelegate?
    
    private lazy var expandableContentHeightConstraint = expandableContent.heightAnchor.constraint(
        equalToConstant: 0
    )
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    func configure(with model: ExpandableCellModel) {
        titleLabel.text = model.title
        detailsLabel.text = model.description
        
        expanded = model.isExpanded
        
        expandButton.transform = expanded
        ? .init(rotationAngle: .pi - 0.001)
        : .identity
        expandableContentHeightConstraint.isActive = !expanded
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
        ])
        
        contentView.addSubview(expandButton)
        NSLayoutConstraint.activate([
            expandButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            expandButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 28),
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
        ])
        
        contentView.addSubview(expandableContent)
        NSLayoutConstraint.activate([
            expandableContent.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            expandableContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            expandableContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            expandableContent.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            expandableContentHeightConstraint,
        ])
        
        expandableContent.addSubview(detailsLabel)
        let detailsBottomConstraint = detailsLabel.bottomAnchor.constraint(
            lessThanOrEqualTo: expandableContent.bottomAnchor, constant: -12
        )
        detailsBottomConstraint.priority = .fittingSizeLevel
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: expandableContent.topAnchor, constant: 12),
            detailsLabel.leadingAnchor.constraint(equalTo: expandableContent.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: expandableContent.trailingAnchor),
            detailsBottomConstraint
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        expandableContent.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        expandButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        detailsLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        detailsLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
       
        
        selectionStyle = .none
        
        expandButton.addAction(.init { [weak self] _ in
            guard
                let self = self,
                let tableView = self.superview as? UITableView
            else {
                return
            }
            
            self.expanded = !self.expanded
            
            tableView.beginUpdates()
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
                    self.expandButton.transform = self.expanded
                    ? .init(rotationAngle: .pi - 0.001)
                    : .identity
                    self.expandableContentHeightConstraint.isActive = !self.expanded
                    self.contentView.layoutIfNeeded()
                }, completion: { completed in
                    self.expanded = completed ? self.expanded : !self.expanded
                    self.expandButton.transform = self.expanded
                    ? .init(rotationAngle: .pi - 0.001)
                    : .identity
                    self.expandableContentHeightConstraint.isActive = !self.expanded
                    
                    if completed {
                        self.delegate?.expandableTableViewCell(self, expanded: self.expanded)
                    }
                }
            )
            
            tableView.endUpdates()
        }, for: .primaryActionTriggered)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let expandableContent: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
