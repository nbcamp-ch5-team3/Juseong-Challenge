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
    
    // MARK: - UseCase
    
    func makeFetchHomeMusicUseCase() -> FetchHomeMusicUseCase {
        FetchHomeMusicUseCase(repository: makeMusicRepository())
    }
    
    // MARK: - ViewModel
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(useCase: makeFetchHomeMusicUseCase())
    }
    
    // MARK: - ViewController
    
    func makeHomeViewController() -> HomeViewController {
        HomeViewController(
            viewModel: makeHomeViewModel(),
            diContainer: self
        )
    }
}
