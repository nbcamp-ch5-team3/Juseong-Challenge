//
//  SectionHeaderView.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit
import SnapKit

final class SectionHeaderView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SectionHeaderView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        backgroundColor = .green
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        
    }
}

