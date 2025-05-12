//
//  Season.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

enum Season: Int, CaseIterable {
    case spring, summer, fall, winter
    
    var queryKeyword: String {
        switch self {
        case .spring: return "봄"
        case .summer: return "여름"
        case .fall: return "가을"
        case .winter: return "겨울"
        }
    }
}
