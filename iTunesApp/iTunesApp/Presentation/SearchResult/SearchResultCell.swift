//
//  SearchResultCell.swift
//  iTunesApp
//
//  Created by 박주성 on 5/14/25.
//

import UIKit
import SnapKit
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
        view.backgroundColor = .secondarySystemBackground
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
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Update
    
    private func updateAlbumImage(with artworkURLString: String) {
        let highResURLString = artworkURLString.replacingOccurrences(of: "30x30", with: "500x500")
        guard let url = URL(string: highResURLString) else { return }

        albumImageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.25))]
        )
    }
    
    func update(item: SearchItem) {
        switch item {
        case .movie(let movie):
            trackNameLabel.text = movie.title
            artistNameLabel.text = movie.director
            updateAlbumImage(with: movie.artworkURL)
        case .podcast(let podcast):
            trackNameLabel.text = podcast.title
            artistNameLabel.text = podcast.artistName
            updateAlbumImage(with: podcast.artworkURL)
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
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        albumImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
