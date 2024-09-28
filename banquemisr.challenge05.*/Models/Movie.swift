//
//  Movie.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-26.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
//    let totalPages: Int
//    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String
    let releaseDate: String
    let overview: String
    let runtime: Int?
    let genres: [Genre]?
    let voteAverage: Float
    let backdropPath: String
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
        case runtime
        case genres
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
        case language = "original_language"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
