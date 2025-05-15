//
//  SearchItem.swift
//  iTunesApp
//
//  Created by 박주성 on 5/15/25.
//

enum SearchItem: Hashable {
    case movie(MovieEntity)
    case podcast(PodcastEntity)
}
