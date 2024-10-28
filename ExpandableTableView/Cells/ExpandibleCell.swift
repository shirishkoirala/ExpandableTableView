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
        
        footerLabel.text = model.footer
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
        ])
        
        cardView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: cardView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        cardView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 28),
        ])
        
        cardView.addSubview(expandButton)
        NSLayoutConstraint.activate([
            expandButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            expandButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 28),
            expandButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -28),
        ])
        
        cardView.addSubview(expandableContent)
        NSLayoutConstraint.activate([
            expandableContent.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            expandableContent.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 28),
            expandableContent.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -28),
            expandableContent.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12),
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
        
        cardView.addSubview(footerLabel)
        NSLayoutConstraint.activate([
            footerLabel.topAnchor.constraint(equalTo: expandableContent.bottomAnchor, constant: 12),
            footerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -28),
            footerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 28),
        ])
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
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
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .card
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let expandView: ExpandView = {
        let view = ExpandView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
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
    
    private let expandableContent: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
