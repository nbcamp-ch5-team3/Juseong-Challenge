//
//  FetchHomeMusicUseCase.swift
//  iTunesApp
//
//  Created by 박주성 on 5/10/25.
//

import Foundation

final class FetchHomeMusicUseCase {
    private let repository: MusicRepository
    
    init(repository: MusicRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<[SeasonalMusics], Error> {
        do {
            async let springMusics = await repository.fetchMusics(for: .spring)
            async let summerMusics = await repository.fetchMusics(for: .summer)
            async let fallMusics = await repository.fetchMusics(for: .fall)
            async let winterMusics = await repository.fetchMusics(for: .winter)

            let seasonalMusics: [SeasonalMusics] = try await [
                .init(season: Season.spring, musics: springMusics),
                .init(season: Season.summer, musics: summerMusics),
                .init(season: Season.fall, musics: fallMusics),
                .init(season: Season.winter, musics: winterMusics)
            ]

            return .success(seasonalMusics)
        } catch {
            return .failure(error)
        }
    }
}
