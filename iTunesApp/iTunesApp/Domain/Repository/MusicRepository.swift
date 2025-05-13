//
//  MusicRepository.swift
//  iTunesApp
//
//  Created by 박주성 on 5/10/25.
//

import Foundation

protocol MusicRepository {
    func fetchMusics(for season: Season) async throws -> [MusicEntity]
}
