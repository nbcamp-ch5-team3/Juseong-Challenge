//
//  SearchResultView.swift
//  iTunesApp
//
//  Created by 박주성 on 5/14/25.
//

import UIKit
import SnapKit

final class SearchResultView: UIView {
    
    // MARK: - Section & Item
    
    typealias Section = Int
    typealias Item = SearchItem
    
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createCollectionViewLayout()
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    // MARK: - Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CollectionView Layout
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 20
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Configure Datasource
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchResultCell, Item>  { cell, indexPath, item in
            cell.update(item: item)
        }
        
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    // MARK: - Snapshot
    
    func applySnapshot(with items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
    }
}

private extension SearchResultView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        backgroundColor = .systemBackground
    }
    
    func setHierarchy() {
        addSubview(collectionView)
    }
    
    func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
