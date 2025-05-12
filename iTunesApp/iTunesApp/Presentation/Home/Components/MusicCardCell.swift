//
//  MusicCardCell.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit

class MusicCardCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MusicCardCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        contentView.backgroundColor = .red
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        
    }
}
