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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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

// MARK: - ViewController Configure

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

        searchController.searchBar.placeholder = "영화, 팟캐스트 검색"
    }
    
    func setBindings() {
        viewModel.state
            .asDriver()
            .drive { [weak self] state in
                guard let self else { return }
                switch state {
                case .homeScreenMusics(let musics):
                    self.homeView.applySnapshot(with: musics)
                case .networkError(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
