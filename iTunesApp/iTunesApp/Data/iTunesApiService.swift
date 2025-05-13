//
//  iTunesApiService.swift
//  iTunesApp
//
//  Created by 박주성 on 5/12/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL       // URL 생성 실패
    case responseError    // 서버 응답 오류
    case decodingError    // JSON 디코딩 실패
}

final class iTunesApiService {
    
    // MARK: - 음악 불러오기
    
    func fetchMusics(term: String) async throws -> MusicDTO {
        var components = URLComponents(string: ITunesAPI.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "country", value: ITunesAPI.country),
            URLQueryItem(name: "media", value: ITunesAPI.Music.media),
            URLQueryItem(name: "entity", value: ITunesAPI.Music.entity),
            URLQueryItem(name: "limit", value: ITunesAPI.Music.limit),
            URLQueryItem(name: "term", value: term)
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        guard let dto = try? JSONDecoder().decode(MusicDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return dto
    }
    
    // MARK: - 영화 불러오기
    
    func fetchMovies(term: String) async throws -> MovieDTO {
        var components = URLComponents(string: ITunesAPI.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "country", value: ITunesAPI.country),
            URLQueryItem(name: "media", value: ITunesAPI.Movie.media),
            URLQueryItem(name: "term", value: term)
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        guard let dto = try? JSONDecoder().decode(MovieDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return dto
    }
    
    // MARK: - 팟캐스트 불러오기
    
    func fetchPodcasts(term: String) async throws -> PodcastDTO {
        var components = URLComponents(string: ITunesAPI.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "country", value: ITunesAPI.country),
            URLQueryItem(name: "media", value: ITunesAPI.Podcast.media),
            URLQueryItem(name: "term", value: term)
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        guard let dto = try? JSONDecoder().decode(PodcastDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return dto
    }

}
