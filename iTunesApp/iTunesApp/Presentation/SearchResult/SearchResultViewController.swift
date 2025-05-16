//
//  SearchResultViewController.swift
//  iTunesApp
//
//  Created by 박주성 on 5/10/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchResultViewModel
    private let diContainer: DIContainer
    
    // MARK: - UI Components
    
    private let searchResultView = SearchResultView()
    
    // MARK: - Initailizer
    
    init(viewModel: SearchResultViewModel, diContainer: DIContainer) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = searchResultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Method
    
    func search(keyword: String) {
        viewModel.action.accept(.search(keyword))
    }
    
    func updateScope(index: Int) {
        viewModel.action.accept(.changeScope(index))
    }
}

// MARK: - Configure

private extension SearchResultViewController {
    func configure() {
        setAttributes()
        setBindings()
    }
    
    func setAttributes() {
        hero.isEnabled = true
    }
    
    func setBindings() {
        viewModel.state
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, state in
                switch state {
                case .searchResults(let items):
                    owner.searchResultView.applySnapshot(with: items)
                case .networkError(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        searchResultView.itemSelected
            .map { item -> DetailMedia in
                switch item {
                case .movie(let movie): return .movie(movie)
                case .podcast(let podcast): return .podcast(podcast)
                }
            }
            .bind(with: self) { owner, detailMedia in
                let detailVC = DetailViewController(detailMedia: detailMedia)
                detailVC.modalPresentationStyle = .fullScreen
                detailVC.hero.modalAnimationType = .selectBy(
                    presenting: .zoom,
                    dismissing: .fade
                )
                owner.present(detailVC, animated: true)
            }
            .disposed(by: disposeBag)

    }
}
