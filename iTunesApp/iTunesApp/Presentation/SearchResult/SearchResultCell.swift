//
//  SearchResultCell.swift
//  iTunesApp
//
//  Created by 박주성 on 5/14/25.
//

import UIKit
import SnapKit
import SkeletonView
import Kingfisher

final class SearchResultCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let labelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                trackNameLabel,
                artistNameLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: - Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setSkeletonableViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        albumImageView.image = nil
        labelContainerView.backgroundColor = .systemGray
        [albumImageView, trackNameLabel, artistNameLabel].forEach {
            $0.hideSkeleton()
        }
    }
    
    // MARK: - Skeleton View
    
    private func setSkeletonableViews() {
        albumImageView.isSkeletonable = true
        trackNameLabel.isSkeletonable = true
        artistNameLabel.isSkeletonable = true
    }

    private func showSkeleton() {
        [albumImageView, trackNameLabel, artistNameLabel].forEach {
            $0.showAnimatedGradientSkeleton()
        }
    }

    private func hideSkeleton() {
        [albumImageView, trackNameLabel, artistNameLabel].forEach {
            $0.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }

    
    // MARK: - UI Update
    
    private func loadAlbumImageAndAdaptColors(from artworkURLString: String) {
        let highResURLString = artworkURLString.replacingOccurrences(of: "30x30", with: "500x500")
        guard let url = URL(string: highResURLString) else { return }
        
        albumImageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            if case .success(let value) = result,
               let averageColor = value.image.averageColor() {
                self.adaptLabelColors(basedOn: averageColor)
                self.hideSkeleton()
            }
        }
    }
    
    private func adaptLabelColors(basedOn color: UIColor) {
        labelContainerView.backgroundColor = color

        let textColor: UIColor = color.isDarkColor ? .white : .black
        trackNameLabel.textColor = textColor
        artistNameLabel.textColor = textColor
    }
    
    func update(item: SearchItem) {
        showSkeleton()
        
        switch item {
        case .movie(let movie):
            trackNameLabel.text = movie.title
            artistNameLabel.text = movie.director
            loadAlbumImageAndAdaptColors(from: movie.artworkURL)
        case .podcast(let podcast):
            trackNameLabel.text = podcast.title
            artistNameLabel.text = podcast.artistName
            loadAlbumImageAndAdaptColors(from: podcast.artworkURL)
        }
    }
}

private extension SearchResultCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }
        
    func setHierarchy() {
        addSubview(containerView)
        
        [
            albumImageView,
            labelContainerView
        ].forEach { containerView.addSubview($0) }
        
        labelContainerView.addSubview(labelStackView)
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
                
        labelContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        labelStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        albumImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
