//
//  PodcastEntity.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

struct PodcastEntity: Hashable {
    let id: String
    let title: String
    let artistName: String
    let podcastURL: URL
    let artworkURL: String
    let releaseDate: Date
    let episodeCount: Int
    let durationInSeconds: Int?
    let genres: [String]
}
