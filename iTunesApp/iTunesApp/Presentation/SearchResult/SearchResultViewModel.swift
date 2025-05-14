//
//  SearchResultViewModel.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation
import RxSwift
import RxRelay

final class SearchResultViewModel {
    
    // MARK: - State & Action

    enum State {
        case searchResults(SearchResult)
        case networkError(Error)
    }
    
    enum Action {
        case search(String)
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    let state = PublishRelay<State>()
    let action = PublishRelay<Action>()
    
    private let usecase: FetchSearchResultUseCase
    
    // MARK: - Initailzer
    
    init(usecase: FetchSearchResultUseCase) {
        self.usecase = usecase
        bind()
    }
    
    // MARK: - Bind
    
    private func bind() {
        action
            .subscribe { [weak self] action in
                guard let self else { return }
                
                switch action {
                case .search(let keyword):
                    Task { await self.fetchSearchResults(keyword: keyword) }
                }
            }
            .disposed(by: disposeBag)
    }
        
    // MARK: - Method
    
    private func fetchSearchResults(keyword: String) async {
        guard let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let result = await usecase.execute(term: query)
        
        switch result {
        case .success(let searchResult):
            self.state.accept(.searchResults(searchResult))
        case .failure(let error):
            self.state.accept(.networkError(error))
        }
    }
}
