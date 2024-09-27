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
    let title: String
    let posterPath: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
