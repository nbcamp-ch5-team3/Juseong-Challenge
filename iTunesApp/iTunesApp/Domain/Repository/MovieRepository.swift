//
//  MovieRepository.swift
//  iTunesApp
//
//  Created by 박주성 on 5/13/25.
//

import Foundation

protocol MovieRepository {
    func fetchMovies(for term: String) async throws -> [MovieEntity]
}
