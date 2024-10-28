//
//  ExpandView.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//
import UIKit
protocol ExpandViewDelegate: AnyObject {
    func didExpand(_ expandView: ExpandView)
}

class ExpandView: UIView {
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    var expanded: Bool = false {
        didSet {
            expandButton.transform = expanded
            ? .init(rotationAngle: .pi - 0.001)
            : .identity
        }
    }
    
    var delegate: ExpandViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
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
    @objc private func onExpand() {
        self.expanded = !self.expanded
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: {
                self.expandButton.transform = self.expanded
                ? .init(rotationAngle: .pi - 0.001)
                : .identity
            }, completion: { completed in
                self.expanded = completed ? self.expanded : !self.expanded
                self.expandButton.transform = self.expanded
                ? .init(rotationAngle: .pi - 0.001)
                : .identity
                self.delegate?.didExpand(self)
            }
        )
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
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onExpand), for: .touchUpInside)
        return button
    }()
}
