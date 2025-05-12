//
//  Constants.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import Foundation

enum ITunesAPI {
    static let baseURL = "https://itunes.apple.com/search"
    static let country = Locale.current.region?.identifier.lowercased() ?? "kr"
    
    enum Music {
        static let media = "music"
        static let entity = "musicTrack"
        static let limit = "30"
    }
}
