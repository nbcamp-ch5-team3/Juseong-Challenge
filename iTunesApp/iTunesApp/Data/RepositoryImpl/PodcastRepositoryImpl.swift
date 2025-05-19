//
//  PodcastRepositoryImpl.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

final class PodcastRepositoryImpl: PodcastRepository {
    
    private let apiService: iTunesApiService

    init(apiService: iTunesApiService) {
        self.apiService = apiService
    }

    func fetchPodcasts(for term: String) async throws -> [PodcastEntity] {
        let dto = try await apiService.fetchPodcasts(term: term)
        return dto.results.compactMap { toEntity($0) }
    }

    // MARK: - Mapping

    private func toEntity(_ dto: PodcastResult) -> PodcastEntity? {
        let formatter = ISO8601DateFormatter()
        
        guard
            let podcastURL = URL(string: dto.trackViewURL),
            let parsedDate = formatter.date(from: dto.releaseDate)
        else {
            return nil
        }

        return PodcastEntity(
            id: "\(dto.trackId)",
            title: dto.trackName,
            artistName: dto.artistName,
            podcastURL: podcastURL,
            artworkURL: dto.artworkUrl30,
            releaseDate: parsedDate,
            episodeCount: dto.trackCount,
            durationInSeconds: dto.trackTimeMillis.map { $0 / 1000 },
            genres: dto.genres
        )
    }
}
