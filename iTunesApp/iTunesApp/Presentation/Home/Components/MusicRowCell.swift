//
//  MusicRowCell.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit
import SnapKit
import Kingfisher

class MusicRowCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                albumImageView,
                verticalStackView
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                trackNameLabel,
                artistNameLabel,
                albumNameLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    // MARK: - Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        albumImageView.image = nil
    }
    
    // MARK: - Update UI
    
    func update(with music: MusicEntity, isLast: Bool) {
        albumNameLabel.text = music.collectionName
        trackNameLabel.text = music.trackName
        artistNameLabel.text = music.artistName
        separatorView.isHidden = isLast
        
        let highResArtworkURLString = music.artworkURLString.replacingOccurrences(of: "30x30", with: "100x100")
        guard let artworkURL = URL(string: highResArtworkURLString) else { return }
        
        albumImageView.kf.setImage(
            with: artworkURL,
            options: [
                .transition(.fade(0.25))
            ]
        )
    }
}

// MARK: - Cell Configure

private extension MusicRowCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        [horizontalStackView, separatorView].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        albumImageView.snp.makeConstraints {
            $0.height.equalTo(verticalStackView.snp.height)
            $0.width.equalTo(albumImageView.snp.height)
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
