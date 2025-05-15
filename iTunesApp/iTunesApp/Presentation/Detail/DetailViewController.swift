//
//  DetailViewController.swift
//  iTunesApp
//
//  Created by 박주성 on 5/10/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let detailView = DetailView()
    private let detailMedia: DetailMedia
    
    // MARK: - Initailizer
    
    init(detailMedia: DetailMedia) {
        self.detailMedia = detailMedia
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.update(with: detailMedia)
    }
}
