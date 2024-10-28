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
        detailsLabel.text = model.description
        
        expanded = model.isExpanded
        
        expandView.expanded = expanded
        expandView.titleText = model.title
        
        headerView.titleText = model.heading
        
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
            headerView.heightAnchor.constraint(equalToConstant: 42),
        ])
        
        cardView.addSubview(expandView)
        NSLayoutConstraint.activate([
            expandView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            expandView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            expandView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])
        
        cardView.addSubview(expandableContent)
        NSLayoutConstraint.activate([
            expandableContent.topAnchor.constraint(equalTo: expandView.bottomAnchor),
            expandableContent.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            expandableContent.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            expandableContent.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor),
            expandableContentHeightConstraint,
        ])
        
        expandableContent.addArrangedSubview(detailsLabel)
        expandableContent.addArrangedSubview(numbersView)
        
        cardView.addSubview(footerLabel)
        NSLayoutConstraint.activate([
            footerLabel.topAnchor.constraint(equalTo: expandableContent.bottomAnchor, constant: 12),
            footerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),
            footerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 28),
            footerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 28),
        ])
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    private let numbersView: NumbersView = {
        let view = NumbersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private lazy var expandView: ExpandView = {
        let view = ExpandView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private let expandableContent: ContentView = {
        let view = ContentView()
        view.backgroundColor = .darkCard
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

extension ExpandibleCell: ExpandViewDelegate {
    func didExpand(_ expandView: ExpandView) {
        guard let tableView = self.superview as? UITableView
        else { return }
        
        self.expanded = expandView.expanded
        
        tableView.beginUpdates()
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: {
                self.expandableContentHeightConstraint.isActive = !self.expanded
                self.contentView.layoutIfNeeded()
                self.expandableContent.alpha = self.expanded ? 1 : 0
            }, completion: { completed in
                self.expandableContentHeightConstraint.isActive = !self.expanded
                if completed {
                    self.delegate?.expandableTableViewCell(self, expanded: self.expanded)
                }
            }
        )
        tableView.endUpdates()
    }
}
