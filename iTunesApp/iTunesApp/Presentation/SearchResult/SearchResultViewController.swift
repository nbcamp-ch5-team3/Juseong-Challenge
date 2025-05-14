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
        setBindings()
    }
    
    func setBindings() {
        viewModel.state
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] state in
                guard let self else { return }
                switch state {
                case .searchResults(let items):
                    self.searchResultView.applySnapshot(with: items)
                case .networkError(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
