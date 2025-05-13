//
//  FetchHomeMusicUseCaseTests.swift
//  iTunesAppTests
//
//  Created by 박주성 on 5/12/25.
//

import XCTest
@testable import iTunesApp

final class FetchHomeMusicUseCaseTests: XCTestCase {

    func test_execute_returnsMockedSeasonalMusics() async {
        let useCase = FetchHomeMusicUseCase(repository: MockMusicRepository())
        let result = await useCase.execute()

        switch result {
        case .success(let seasonalMusics):
            XCTAssertEqual(seasonalMusics.count, 4)
            XCTAssertEqual(seasonalMusics.first(where: { $0.season == .spring })?.musics.count, 1)
            XCTAssertEqual(seasonalMusics.first(where: { $0.season == .summer })?.musics.count, 1)
            XCTAssertEqual(seasonalMusics.first(where: { $0.season == .fall })?.musics.count, 0)
        case .failure:
            XCTFail("Should not fail")
        }
    }
}
