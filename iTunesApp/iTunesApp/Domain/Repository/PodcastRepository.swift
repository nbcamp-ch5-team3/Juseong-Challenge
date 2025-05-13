//
//  PodcastRepository.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

protocol PodcastRepository {
    func fetchPodcasts(for term: String) async throws -> [PodcastEntity]
}
