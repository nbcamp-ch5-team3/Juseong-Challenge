//
//  MovieRepositoryImpl.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

final class MovieRepositoryImpl: MovieRepository {
    
    private let apiService: iTunesApiService
    
    init(apiService: iTunesApiService) {
        self.apiService = apiService
    }
    
    func fetchMovies(for term: String) async throws -> [MovieEntity] {
        let dto = try await apiService.fetchMovies(term: term)
        return dto.results.compactMap { toEntity($0) }
    }
    
    // MARK: - Mapping
    
    private func toEntity(_ dto: MovieResult) -> MovieEntity? {
            let formatter = ISO8601DateFormatter()
            
            guard
                let movieURL = URL(string: dto.trackViewURL),
                let previewURL = URL(string: dto.previewURL),
                let parsedDate = formatter.date(from: dto.releaseDate)
            else {
                return nil
            }

            return MovieEntity(
                title: dto.trackName,
                director: dto.artistName,
                movieURL: movieURL,
                previewURL: previewURL,
                artworkURL: dto.artworkUrl30,
                releaseDate: parsedDate,
                durationInSeconds: dto.trackTimeMillis / 1000,
                genre: dto.primaryGenreName,
                rating: dto.contentAdvisoryRating,
                description: dto.longDescription
            )
        }

}
