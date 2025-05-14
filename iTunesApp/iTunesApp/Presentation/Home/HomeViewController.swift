//
//  HomeViewController.swift
//  iTunesApp
//
//  Created by 박주성 on 5/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let diContainer: DIContainer
    private let viewModel: HomeViewModel
    
    // MARK: - UI Components
    
    private let homeView = HomeView()
    
    private lazy var searchResultViewController: SearchResultViewController = {
        return diContainer.makeSearchResultViewController()
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: searchResultViewController)
        controller.searchBar.placeholder = "영화, 팟캐스트 검색"
        controller.searchBar.scopeButtonTitles = ["Movie", "Podcast"]
        controller.obscuresBackgroundDuringPresentation = true
        return controller
    }()
    
    // MARK: - Initailizer
    
    init(viewModel: HomeViewModel, diContainer: DIContainer) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.action.accept(.viewDidLoad)
    }
}

// MARK: - Configure

private extension HomeViewController {
    func configure() {
        setAttributes()
        setBindings()
    }
    
    func setAttributes() {
        navigationItem.title = "Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setBindings() {
        viewModel.state
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] state in
                guard let self else { return }
                switch state {
                case .homeScreenMusics(let musics):
                    self.homeView.applySnapshot(with: musics)
                case .networkError(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(1_000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .bind(onNext: { [weak self] keyword in
                guard let self = self else { return }
                self.searchResultViewController.search(keyword: keyword)
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.selectedScopeButtonIndex
            .distinctUntilChanged()
            .bind(onNext: { [weak self] index in
                guard let self else { return }
                self.searchResultViewController.updateScope(index: index)
            })
            .disposed(by: disposeBag)
    }
}
