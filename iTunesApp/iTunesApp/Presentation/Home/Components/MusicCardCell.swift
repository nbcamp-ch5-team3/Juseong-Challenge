//
//  MusicCardCell.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MusicCardCell: UICollectionViewCell {
    
    // MARK: - UI Componetns
    
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
    
    private let labelContainerView = UIView()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "1"
        return label
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
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        albumImageView.image = nil
    }
    
    // MARK: - UI Update
    
    private func updateLabels(with music: MusicEntity, index: Int) {
        trackNameLabel.text = music.trackName
        artistNameLabel.text = music.artistName
        numberLabel.text = "\(calculateDisplayIndex(from: index))"
    }

    private func calculateDisplayIndex(from index: Int) -> Int {
        if index < 3 {
            return index + 8
        } else if index > 12 {
            return index - 12
        } else {
            return index - 2
        }
    }

    private func loadAlbumImageAndAdaptColors(from artworkURLString: String) {
        let highResURLString = artworkURLString.replacingOccurrences(of: "30x30", with: "500x500")
        guard let url = URL(string: highResURLString) else { return }
        
        albumImageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            if case .success(let value) = result,
               let averageColor = value.image.averageColor() {
                self.adaptLabelColors(basedOn: averageColor)
            }
        }
    }
    
    private func adaptLabelColors(basedOn color: UIColor) {
        labelContainerView.backgroundColor = color

        let textColor: UIColor = color.isDarkColor ? .white : .black
        numberLabel.textColor = textColor
        trackNameLabel.textColor = textColor
        artistNameLabel.textColor = textColor
    }

    func update(with music: MusicEntity, _ index: Int) {
        updateLabels(with: music, index: index)
        loadAlbumImageAndAdaptColors(from: music.artworkURLString)
    }
}

// MARK: - Configure

private extension MusicCardCell {
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
        
        [
            numberLabel,
            labelStackView
        ].forEach { labelContainerView.addSubview($0) }
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        albumImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(numberLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
