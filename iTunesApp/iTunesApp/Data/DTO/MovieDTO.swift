//
//  MovieDTO.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

struct MovieDTO: Decodable {
    let results: [MovieResult]
}

struct MovieResult: Decodable {
    let trackId: Int
    let artistName: String
    let trackName: String
    let trackViewURL: String
    let previewURL: String
    let artworkUrl30: String
    let releaseDate: String
    let trackTimeMillis: Int
    let primaryGenreName: String?
    let contentAdvisoryRating: String?
    let longDescription: String

    enum CodingKeys: String, CodingKey {
        case trackId
        case artistName
        case trackName
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30
        case releaseDate
        case trackTimeMillis
        case primaryGenreName
        case contentAdvisoryRating
        case longDescription
    }
}
