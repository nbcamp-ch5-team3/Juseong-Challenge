//
//  MusicDTO.swift
//  iTunesApp
//
//  Created by 박주성 on 5/11/25.
//

import Foundation

struct MusicDTO: Decodable {
    let results: [MusicResult]
}

struct MusicResult: Decodable {
    let trackId: Int
    let artistName: String
    let collectionName: String?
    let trackName: String
    let trackViewURL: String
    let previewURL: String?
    let artworkUrl30: String
    let releaseDate: String
    let trackTimeMillis: Int?
    
    enum CodingKeys: String, CodingKey {
        case trackId
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
