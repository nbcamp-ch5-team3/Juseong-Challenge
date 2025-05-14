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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: SearchItem) {
        print(item)
        switch item {
        case .movie(_):
            contentView.backgroundColor = .red
        case .podcast(_):
            contentView.backgroundColor = .green
        }
    }
}
