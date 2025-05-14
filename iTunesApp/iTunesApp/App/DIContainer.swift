//
//  DIContainer.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import UIKit

final class DIContainer {
    
    // MARK: - API Service
    
    private let apiService = iTunesApiService()
    
    // MARK: - Repository
    
    func makeMusicRepository() -> MusicRepository {
        MusicRepositoryImpl(apiService: apiService)
    }
    
    func makeMovieRepository() -> MovieRepository {
        MovieRepositoryImpl(apiService: apiService)
    }
    
    func makePodcastRepository() -> PodcastRepository {
        PodcastRepositoryImpl(apiService: apiService)
    }
    
    // MARK: - UseCase
    
    func makeFetchHomeMusicUseCase() -> FetchHomeMusicUseCase {
        FetchHomeMusicUseCase(repository: makeMusicRepository())
    }
    
    func makeFetchSearchResultUseCase() -> FetchSearchResultUseCase {
        FetchSearchResultUseCase(
            movieRepository: makeMovieRepository(),
            podcastRepository: makePodcastRepository()
        )
    }
    
    // MARK: - ViewModel
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(useCase: makeFetchHomeMusicUseCase())
    }
    
    func makeSearchResultViewModel() -> SearchResultViewModel {
        SearchResultViewModel(usecase: makeFetchSearchResultUseCase())
    }
    
    // MARK: - ViewController
    
    func makeHomeViewController() -> HomeViewController {
        HomeViewController(
            viewModel: makeHomeViewModel(),
            diContainer: self
        )
    }
    
    func makeSearchResultViewController() -> SearchResultViewController {
        SearchResultViewController(
            viewModel: makeSearchResultViewModel(),
            diContainer: self
        )
    }
}
