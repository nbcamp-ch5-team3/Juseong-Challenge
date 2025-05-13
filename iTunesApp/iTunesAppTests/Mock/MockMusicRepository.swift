//
//  MockMusicRepository.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import Foundation
@testable import iTunesApp

final class MockMusicRepository: MusicRepository {
    private let mockData: [Season: [MusicEntity]] = [
        .spring: [
            MusicEntity(
                trackName: "봄 노래",
                artistName: "벚꽃 가수",
                collectionName: "봄 앨범",
                artworkURL: URL(string: "https://example.com")!,
                releaseDate: Date(),
                trackURL: URL(string: "https://example.com")!,
                previewURL: URL(string: "https://example.com")!,
                durationInSeconds: 180
            )
        ],
        .summer: [
            MusicEntity(
                trackName: "여름 노래",
                artistName: "바다 가수",
                collectionName: "여름 앨범",
                artworkURL: URL(string: "https://example.com")!,
                releaseDate: Date(),
                trackURL: URL(string: "https://example.com")!,
                previewURL: URL(string: "https://example.com")!,
                durationInSeconds: 200
            )
        ],
        .fall: [],
        .winter: []
    ]

    func fetchMusics(for season: Season) async -> [MusicEntity] {
        return mockData[season] ?? []
    }
}
