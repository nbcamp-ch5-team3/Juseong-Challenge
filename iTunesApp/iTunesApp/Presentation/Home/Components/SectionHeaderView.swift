//
//  SectionHeaderView.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit
import SnapKit

final class SectionHeaderView: UICollectionReusableView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with season: Season) {
        switch season {
        case .spring:
            titleLabel.text = "봄 Best"
            descriptionLabel.text = "봄에 어울리는 음악 Best 5"
        case .summer:
            titleLabel.text = "여름"
            descriptionLabel.text = "여름에 어울리는 음악"
        case .fall:
            titleLabel.text = "가을"
            descriptionLabel.text = "가을에 어울리는 음악"
        case .winter:
            titleLabel.text = "겨울"
            descriptionLabel.text = "겨울에 어울리는 음악"
        }
    }
}

private extension SectionHeaderView {
    func configure() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        addSubview(stackView)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
