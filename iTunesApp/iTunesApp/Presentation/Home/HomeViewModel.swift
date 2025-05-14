//
//  HomeViewModel.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel {
    
    // MARK: - State & Action
    
    enum State {
        case homeScreenMusics([SeasonalMusics])
        case networkError(Error)
    }
    
    enum Action {
        case viewDidLoad
    }
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    let state = BehaviorRelay<State>(value: .homeScreenMusics([]))
    let action = PublishRelay<Action>()
    
    private let useCase: FetchHomeMusicUseCase
    
    // MARK: - Initailizer
    
    init(useCase: FetchHomeMusicUseCase) {
        self.useCase = useCase
        bind()
    }
    
    // MARK: - Bind
    
    private func bind() {
        action
            .subscribe { [weak self] action in
                guard let self else { return }
                
                switch action {
                case .viewDidLoad:
                    Task { await self.fetchSeasonalMusics() }
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Method
    
    private func fetchSeasonalMusics() async {
        let result = await useCase.execute()
        
        switch result {
        case .success(let musics):
            state.accept(.homeScreenMusics(musics))
        case .failure(let error):
            state.accept(.networkError(error))
        }
    }
}
