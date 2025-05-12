//
//  HomeViewController.swift
//  iTunesApp
//
//  Created by 박주성 on 5/8/25.
//

import UIKit
import RxSwift
import RxRelay

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposebag = DisposeBag()
    private let diContaitner: DIContainer
    private let viewModel: HomeViewModel
    
    // MARK: - UI Components
    
    private let homeView = HomeView()
    
    // MARK: - Initailizer
    
    init(viewModel: HomeViewModel, diContatiner: DIContainer) {
        self.viewModel = viewModel
        self.diContaitner = diContatiner
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
        setHierarchy()
        setConstraints()
        setBindings()
    }
    
    func setAttributes() {
        
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        
    }
    
    func setBindings() {
        viewModel.state
            .subscribe { [weak self] state in
                guard let self else { return }
                
                switch state {
                case .homeScreenMusics(let musics):
                    self.homeView.applySnapshot(with: musics)
                case .networkError(let error):
                    print(error)
                }
            }
            .disposed(by: disposebag)
    }
}
