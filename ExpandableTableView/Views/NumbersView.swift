//
//  NumbersView.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//

import UIKit

class NumbersView: UIView {
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
    private func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.contentSize.height
        collectionViewHeightConstraint?.constant = contentHeight
    }
    private func setupViews() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint?.isActive = true
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Numbers"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NumbersCell.self, forCellWithReuseIdentifier: NumbersCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
}

extension NumbersView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumbersCell.identifier, for: indexPath) as! NumbersCell
        cell.number = "\(indexPath.row)"
        return cell
    }
}
