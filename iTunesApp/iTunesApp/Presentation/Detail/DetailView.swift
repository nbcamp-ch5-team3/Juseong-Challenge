//
//  DetailView.swift
//  iTunesApp
//
//  Created by 박주성 on 5/15/25.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    let contentView = UIView()
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update Swtich
    
    func update(with media: DetailMedia) {
        switch media {
        case .music(let music):
            updateMusicView(with: music)
        case .movie(let movie):
            updateMovieView(with: movie)
        case .podcast(let podcast):
            updatePodcastView(with: podcast)
        }
    }
}

// MARK: - Update

private extension DetailView {
    func updateMusicView(with music: MusicEntity) {
        loadAlbumImageAndAdaptColors(from: music.artworkURLString)
        trackNameLabel.text = music.trackName
        artistNameLabel.text = music.artistName
    }

    func updateMovieView(with movie: MovieEntity) {
        loadAlbumImageAndAdaptColors(from: movie.artworkURL)
        trackNameLabel.text = movie.title
        artistNameLabel.text = movie.director
    }

    func updatePodcastView(with podcast: PodcastEntity) {
        loadAlbumImageAndAdaptColors(from: podcast.artworkURL)
        trackNameLabel.text = podcast.title
        artistNameLabel.text = podcast.artistName
    }
    
    func loadAlbumImageAndAdaptColors(from artworkURLString: String) {
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
    
    func adaptLabelColors(basedOn color: UIColor) {
        labelContainerView.backgroundColor = color

        let textColor: UIColor = color.isDarkColor ? .white : .black
        trackNameLabel.textColor = textColor
        artistNameLabel.textColor = textColor
    }
}

// MARK: - Configure

private extension DetailView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        backgroundColor = .white
    }
    
    func setHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            albumImageView,
            labelContainerView
        ].forEach { contentView.addSubview($0) }
        
        labelContainerView.addSubview(labelStackView)
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollView.contentLayoutGuide)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        albumImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(albumImageView.snp.width)
        }
        
        labelContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(albumImageView.snp.bottom)
            $0.height.equalTo(70)
        }
        
        labelStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
}
