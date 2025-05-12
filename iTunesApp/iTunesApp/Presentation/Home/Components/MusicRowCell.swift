//
//  MusicRowCell.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit

class MusicRowCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MusicRowCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        contentView.backgroundColor = .blue
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        
    }
}
