//
//  ViewController.swift
//  GlitchyCollectionView
//
//  Created by Jonathon Francis on 26/9/2022.
//

import UIKit

class ViewController: UIViewController {
    enum Section: Int, Hashable {
        case header
        case bottom
    }
    
    enum CellType: Hashable {
        case jarDetail
        case some(Int)
    }
    
    
    private lazy var collectionViewLayout = createLayout()
    private var dataSource: UICollectionViewDiffableDataSource<Section, CellType>!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        setupCollectionView()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        
        snapshot.appendSections([.header])
        snapshot.appendItems([.jarDetail])
        snapshot.appendSections([.bottom])
        snapshot.appendItems(Array(0..<30).map { .some($0) })
        
        dataSource.apply(snapshot)
    }

    private func setupCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Section, CellType>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, cellType in
                switch cellType {
                case .jarDetail:
                    return collectionView.dequeueReusableCell(withReuseIdentifier: "ACell", for: indexPath)
                case .some:
                    return collectionView.dequeueReusableCell(withReuseIdentifier: "BCell", for: indexPath)
                }
            }
        )
        
        collectionView.dataSource = dataSource
    }

    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(ACell.self, forCellWithReuseIdentifier: "ACell")
        collectionView.register(BCell.self, forCellWithReuseIdentifier: "BCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        return collectionView
    }()

    func createLayout() -> UICollectionViewLayout {
        let layout = ScrollingCardCollectionViewLayout { [weak self] sectionInt, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionInt]
            
            switch section {
            case .header:
                return .createFullWidthLayout(estimatedItemHeight: 220, topSpacing: 0)
            case .bottom:
                let section = NSCollectionLayoutSection.createFullWidthLayout(estimatedItemHeight: 40, topSpacing: 0)
                return section
            }
        }
        
        return layout
    }
}

extension NSCollectionLayoutSection {
    static func createFullWidthLayout(estimatedItemHeight: CGFloat, topSpacing: CGFloat = 0) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedItemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedItemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: topSpacing, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

class ACell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        let label = UILabel()
        label.text = "Header"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
        
        let label = UILabel()
        label.text = "Item"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
