//
//  MovieEntity.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

struct MovieEntity: Hashable {
    let id: String
    let title: String
    let director: String
    let movieURL: URL
    let previewURL: URL?
    let artworkURL: String
    let releaseDate: Date
    let durationInSeconds: Int
    let genre: String?
    let rating: String?
    let description: String?
}
