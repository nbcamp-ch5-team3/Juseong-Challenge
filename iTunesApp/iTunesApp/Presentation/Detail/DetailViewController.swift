//
//  DetailViewController.swift
//  iTunesApp
//
//  Created by 박주성 on 5/10/25.
//

import UIKit
import Hero
import RxSwift

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let detailView = DetailView()
    private let detailMedia: DetailMedia
    private let disposeBag = DisposeBag()
    
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
        configure()
        detailView.update(with: detailMedia)
    }
    
    private func showActivityView() {
        let activityItems: URL
        
        switch detailMedia {
        case .music(let music):
            activityItems = music.trackURL
        case .movie(let movie):
            activityItems = movie.movieURL
        case .podcast(let podcast):
            activityItems = podcast.podcastURL
        }
        let activityViewController = UIActivityViewController(activityItems: [activityItems], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

// MARK: - Configure

private extension DetailViewController {
    func configure() {
        setAttributes()
        setBindings()
    }
    
    func setAttributes() {
        self.hero.isEnabled = true
    }
    
    func setBindings() {
        detailView.action
            .asSignal()
            .emit(with: self) { owner, action in
                switch action {
                case .dismiss:
                    owner.dismiss(animated: true)
                case .share:
                    owner.showActivityView()
                }
            }
            .disposed(by: disposeBag)
    }
}
