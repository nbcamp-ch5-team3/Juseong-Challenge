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
        return dto.results.compactMap { toEntity($0) }
    }
    
    // MARK: - Mapping
    
    private func toEntity(_ dto: MusicResult) -> MusicEntity? {
            let formatter = ISO8601DateFormatter()
            
            guard
                let trackURL = URL(string: dto.trackViewURL),
                let preview = dto.previewURL,
                let previewURL = URL(string: preview),
                let parsedDate = formatter.date(from: dto.releaseDate)
            else {
                return nil
            }
            
            return MusicEntity(
                id: "\(dto.trackId)",
                trackName: dto.trackName,
                artistName: dto.artistName,
                collectionName: dto.collectionName ?? "",
                artworkURLString: dto.artworkUrl30,
                releaseDate: parsedDate,
                trackURL: trackURL,
                previewURL: previewURL,
                durationInSeconds: (dto.trackTimeMillis ?? 0) / 1000
            )
        }
}
