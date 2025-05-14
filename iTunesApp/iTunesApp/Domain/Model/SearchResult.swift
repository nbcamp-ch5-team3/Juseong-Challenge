//
//  SearchResult.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

struct SearchResult {
    let movies: [MovieEntity]
    let podcasts: [PodcastEntity]
}

enum SearchItem: Hashable {
    case movie(MovieEntity)
    case podcast(PodcastEntity)
}
