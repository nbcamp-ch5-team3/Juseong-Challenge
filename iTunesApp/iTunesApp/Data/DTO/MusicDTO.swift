//
//  MusicDTO.swift
//  iTunesApp
//
//  Created by 박주성 on 5/11/25.
//

import Foundation

// MARK: - Welcome
struct MusicDTO: Decodable {
    let results: [MusicResult]
}

// MARK: - Result
struct MusicResult: Decodable {
    let artistName: String
    let collectionName: String?
    let trackName: String
    let trackViewURL: String
    let previewURL: String?
    let artworkUrl30: String
    let releaseDate: String
    let trackTimeMillis: Int?
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case collectionName
        case trackName
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30
        case releaseDate
        case trackTimeMillis
    }
}

extension MusicResult {
    func toEntity() -> MusicEntity? {
        
        let formatter = ISO8601DateFormatter()
        
        guard
            let artworkURL = URL(string: artworkUrl30),
            let trackURL = URL(string: trackViewURL),
            let preview = previewURL,
            let previewURL = URL(string: preview),
            let parsedDate = formatter.date(from: releaseDate)
        else {
            return nil // URL 변환 실패 시 전체 무시
        }
        
        return .init(
            trackName: trackName,
            artistName: artistName,
            collectionName: collectionName ?? "",
            artworkURL: artworkURL,
            releaseDate: parsedDate,
            trackURL: trackURL,
            previewURL: previewURL,
            durationInSeconds: (trackTimeMillis ?? 0) / 1000
        )
    }
}
