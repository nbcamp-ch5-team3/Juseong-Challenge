//
//  HomeView.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class HomeView: UIView {
    
    // MARK: - Section & Item
    
    typealias Section = Season
    typealias Item = MusicEntity
    
    // MARK: - Properties
    
    let itemSelected = PublishRelay<MusicEntity>()
    private let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createCollectionViewLayout()
        )
        collectionView.backgroundColor = .systemBackground
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
            heightDimension: .fractionalWidth(0.7)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10
        setInfinityCarousel(to: section)

        return section
    }
    
    // MARK: - Infinity Carousel
    
    private func setInfinityCarousel(to section: NSCollectionLayoutSection) {
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, offset, env in
            guard let self = self else { return }
                       
            let containerWidth = env.container.contentSize.width
            let centerX = containerWidth / 2
            
            let edgeRepeatCount = 3
            let sectionIndex = Section.spring.rawValue
            let totalItems = self.collectionView.numberOfItems(inSection: sectionIndex)
            let realCount = totalItems - edgeRepeatCount - edgeRepeatCount
            
            let centerThreshold: CGFloat = 1.0
            
            // 화면 중앙 포인트
            let centerPoint = CGPoint(
                x: self.collectionView.bounds.midX,
                y: self.collectionView.bounds.midY * 0.3
            )
            guard
                let indexPath = self.collectionView.indexPathForItem(at: centerPoint),
                indexPath.section == sectionIndex,
                let attrs = self.collectionView.layoutAttributesForItem(at: indexPath)
            else { return }
            
            // 셀이 정확히 중앙에 왔는지
            let cellMidX = attrs.frame.midX - offset.x
            let distanceToCenter = abs(cellMidX - centerX)
            guard distanceToCenter < centerThreshold else { return }
            
            let item = indexPath.item
            if item < edgeRepeatCount {
                // 뒤로 무한 스크롤
                let target = IndexPath(item: item + realCount, section: sectionIndex)
                
                self.collectionView.scrollToItem(
                    at: target,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
            else if item >= edgeRepeatCount + realCount {
                // 앞으로 무한 스크롤
                let target = IndexPath(item: item - realCount, section: sectionIndex)
                
                self.collectionView.scrollToItem(
                    at: target,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
        }
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
            heightDimension: .absolute(240)
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
        let springCellRegistration = UICollectionView.CellRegistration<MusicCardCell, Item> { cell, indexPath, item in
            cell.update(with: item, indexPath.row)
            cell.hero.id = item.id
        }

        let defaultCellRegistration = UICollectionView.CellRegistration<MusicRowCell, Item> { cell, indexPath, item in
            let isGroupLast = (indexPath.item + 1) % 3 == 0
            cell.update(with: item, isGroupLast)
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
    
    // MARK: - Snapshot
    
    func applySnapshot(with seasonalMusics: [SeasonalMusics]) {
        guard !seasonalMusics.isEmpty else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        let edgeRepeatCount = 3
        
        seasonalMusics.forEach { seasonalMusic in
            let season = seasonalMusic.season

            if season == .spring {
                let original = Array(seasonalMusic.musics.prefix(10))

                // 앞 3개 + 원본 10개 + 뒤 3개
                let front = original.prefix(edgeRepeatCount).enumerated().map { i, item in
                    var copy = item
                    copy.id = "\(item.id)-head\(i)"
                    return copy
                }

                let middle = original.enumerated().map { i, item in
                    var copy = item
                    copy.id = "\(item.id)-main\(i)"
                    return copy
                }

                let back = original.suffix(edgeRepeatCount).enumerated().map { i, item in
                    var copy = item
                    copy.id = "\(item.id)-tail\(i)"
                    return copy
                }

                let repeated = Array(back + middle + front)
                snapshot.appendItems(repeated, toSection: .spring)
            } else {
                snapshot.appendItems(seasonalMusic.musics, toSection: season)
            }
        }

        dataSource?.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self = self else { return }
            
            let initialIndex = IndexPath(
                item: edgeRepeatCount,
                section: Section.spring.rawValue
            )

            self.collectionView.scrollToItem(
                at: initialIndex,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
}

// MARK: - Configure

private extension HomeView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
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
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setBindings() {
        collectionView.rx.itemSelected
            .compactMap { [weak self] indexPath in
                self?.dataSource?.itemIdentifier(for: indexPath)
            }
            .bind(to: itemSelected)
            .disposed(by: disposeBag)
    }
}
