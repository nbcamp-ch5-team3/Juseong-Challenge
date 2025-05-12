//
//  MusicRepositoryImpl.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import Foundation

final class MusicRepositoryImpl: MusicRepository {
    
    private let apiService: iTunesApiService
    
    init(apiService: iTunesApiService) {
        self.apiService = apiService
    }
    
    func fetchMusics(for season: Season) async throws -> [MusicEntity] {
        let dto = try await apiService.fetchMusics(term: season.queryKeyword)
        return dto.results.compactMap { $0.toEntity() }
    }
}
