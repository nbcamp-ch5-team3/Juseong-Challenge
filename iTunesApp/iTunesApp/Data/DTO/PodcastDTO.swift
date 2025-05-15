//
//  PodcastDTO.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

struct PodcastDTO: Decodable {
    let results: [PodcastResult]
}

struct PodcastResult: Decodable {
    let artistName: String
    let trackName: String
    let trackViewURL: String
    let artworkUrl30: String
    let releaseDate: String
    let trackCount: Int
    let trackTimeMillis: Int?
    let genres: [String]
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
        case trackViewURL = "trackViewUrl"
        case artworkUrl30
        case releaseDate
        case trackCount
        case trackTimeMillis
        case genres
    }
}
