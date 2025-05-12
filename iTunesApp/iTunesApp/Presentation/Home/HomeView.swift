//
//  HomeView.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit

class HomeView: UIView {
    
    // MARK: - Section & Item
    
    typealias Section = Season
    typealias Item = MusicEntity
    
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createCollectionViewLayout()
        )
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.showsVerticalScrollIndicator = false
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
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] (index, env) -> NSCollectionLayoutSection? in
                guard let self else { return nil }
                guard let section = Section(rawValue: index) else { return nil }
                return self.makeSection(for: section)
            },
            configuration: {
                let config = UICollectionViewCompositionalLayoutConfiguration()
                config.interSectionSpacing = 20
                return config
            }()
        )
        return layout
    }
    
    private func makeSection(for section: Section) -> NSCollectionLayoutSection {
        let header = makeHeaderItemLayout()
        let layoutSection: NSCollectionLayoutSection
        
        switch section {
        case .spring:
            layoutSection = springSectionLayout()
        case .summer, .fall, .winter:
            layoutSection = defaultSeasonSectionLayout()
        }
        
        layoutSection.boundarySupplementaryItems = [header]
        return layoutSection
    }
    
    // MARK: - Header Layout
    
    private func makeHeaderItemLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return header
    }
    
    // MARK: - Spring Section Layout
    
    private func springSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalWidth(0.9)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10

        return section
    }
    
    // MARK: - Default Season Layout
    
    private func defaultSeasonSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0 / 3.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10

        return section
    }
    
    // MARK: - Configure Datasource
    
    private func configureDataSource() {
        let springCellRegistration = UICollectionView.CellRegistration<MusicCardCell, Item> { cell, _, item in
            
        }

        let defaultCellRegistration = UICollectionView.CellRegistration<MusicRowCell, Item> { cell, indexPath, item in
            let isGroupLast = (indexPath.item + 1) % 3 == 0
            cell.update(with: item, isLast: isGroupLast)
        }
                
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { header, _, indexPath in
            guard let section = Section(rawValue: indexPath.section) else { return }
            header.update(with: section)
        }

        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else {
                return UICollectionViewCell()
            }

            switch section {
            case .spring:
                return collectionView.dequeueConfiguredReusableCell(
                    using: springCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .summer, .fall, .winter:
                return collectionView.dequeueConfiguredReusableCell(
                    using: defaultCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }
    }
    
    // MARK: - SnapShot
    
    func applySnapshot(with seasonalMusics: [SeasonalMusics]) {
        guard !seasonalMusics.isEmpty else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        seasonalMusics.forEach { seasonalMusic in
            snapshot.appendItems(seasonalMusic.musics, toSection: seasonalMusic.season)
        }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - View Configure

private extension HomeView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        backgroundColor = .secondarySystemBackground
    }
    
    func setHierarchy() {
        addSubview(collectionView)
    }
    
    func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
