//
//  DetailView.swift
//  iTunesApp
//
//  Created by 박주성 on 5/15/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
import Hero

final class DetailView: UIView {
    
    // MARK: - Action
    
    enum Action {
        case dismiss
        case share
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let action = PublishRelay<Action>()
    
    // MARK: - UI Components
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    let contentView = UIView()
    
    private let containerView = UIView() // [albumImageView, labelContainerView]
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let labelContainerView: UIView = { // [labelStackView]
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
        label.textColor = .black
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.arrow.up")
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
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
        
        setHeroIDs(with: music.id)
    }
    
    func updateMovieView(with movie: MovieEntity) {
        loadAlbumImageAndAdaptColors(from: movie.artworkURL)
        trackNameLabel.text = movie.title
        artistNameLabel.text = movie.director
        
        setHeroIDs(with: movie.id)
    }
    
    func updatePodcastView(with podcast: PodcastEntity) {
        loadAlbumImageAndAdaptColors(from: podcast.artworkURL)
        trackNameLabel.text = podcast.title
        artistNameLabel.text = podcast.artistName
        
        setHeroIDs(with: podcast.id)
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
    
    private func setHeroIDs(with id: String) {
        containerView.hero.id = id
    }
}

// MARK: - UIScrollView Delegate

extension DetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 0 {
            let pullDistance = abs(offsetY)
            let maxPullDistance: CGFloat = 80
            let scale = max(0.85, 1 - pullDistance / (maxPullDistance * 5))
            
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            if pullDistance > maxPullDistance {
                action.accept(.dismiss)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
}

// MARK: - Configure

private extension DetailView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }
    
    func setAttributes() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 40
        clipsToBounds = true
    }
    
    func setHierarchy() {
        [
            scrollView,
            cancelButton
        ].forEach { addSubview($0) }
        
        scrollView.addSubview(contentView)
        contentView.addSubview(containerView)
        
        [
            albumImageView,
            labelContainerView
        ].forEach { containerView.addSubview($0) }
        
        [
            labelStackView,
            shareButton
        ].forEach { labelContainerView.addSubview($0) }
    }
    
    func setConstraints() {
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(36)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollView.contentLayoutGuide)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(500)
        }
        
        albumImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(albumImageView.snp.width)
        }
        
        labelContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(albumImageView.snp.bottom)
            $0.height.equalTo(70)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints {
            $0.leading.equalTo(labelStackView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
    
    func setBindings() {
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.action.accept(.dismiss)
            }
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.action.accept(.share)
            }
            .disposed(by: disposeBag)
    }
}
