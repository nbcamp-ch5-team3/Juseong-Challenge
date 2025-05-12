//
//  MusicEntity.swift
//  iTunesApp
//
//  Created by 박주성 on 5/11/25.
//

import Foundation

struct MusicEntity: Hashable {
    let trackName: String
    let artistName: String
    let collectionName: String
    let artworkURLString: String
    let releaseDate: Date
    let trackURL: URL
    let previewURL: URL
    let durationInSeconds: Int
}
