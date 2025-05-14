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
        case searchResults([SearchItem])
        case networkError(Error)
    }
    
    enum Action {
        case search(String)
        case changeScope(Int)
    }
    
    // MARK: - Properties
    
    private var latestResult: SearchResult?
    private var currentScopeIndex: Int = 0 // 0: Movie, 1: Podcast
    
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
                case .changeScope(let index):
                    self.currentScopeIndex = index
                    self.filterItemsForScope(index)
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
            self.latestResult = searchResult
            filterItemsForScope(self.currentScopeIndex)
        case .failure(let error):
            self.state.accept(.networkError(error))
        }
    }
    
    private func filterItemsForScope(_ scopeIndex: Int) {
        guard let result = latestResult else { return }
        
        switch scopeIndex {
        case 0:
            state.accept(.searchResults(result.movies.map { .movie($0) }))
        case 1:
            state.accept(.searchResults(result.podcasts.map { .podcast($0) }))
        default:
            break
        }
    }
}
