//
//  FetchSearchResultUseCase.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

final class FetchSearchResultUseCase {
    private let movieRepository: MovieRepository
    private let podcastRepository: PodcastRepository
    
    init(movieRepository: MovieRepository, podcastRepository: PodcastRepository) {
        self.movieRepository = movieRepository
        self.podcastRepository = podcastRepository
    }
    
    func execute(term: String) async -> Result<SearchResult, Error> {
        do {
            async let movies = movieRepository.fetchMovies(for: term)
            async let podcasts = podcastRepository.fetchPodcasts(for: term)
            
            let searchResults: SearchResult = try await .init(
                movies: movies,
                podcast: podcasts
            )
            
            return .success(searchResults)
        } catch {
            return .failure(error)
        }
    }
}
