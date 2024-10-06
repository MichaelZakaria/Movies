//
//  MockNetworkManager.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Marco on 2024-09-29.
//

import Foundation
@testable import banquemisr_challenge05__

class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnErrorForMovies = false
    var shouldReturnErrorForPoster = false
    
    func fetchData<T: Codable>(endPoint: EndPoints, type: T.Type, handler: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnErrorForMovies {
            handler(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error occurred"])))
        } else {
            let mockResponse = MoviesResponse(page: 1, results: [Movie(id: 0, title: "Mock movie", posterPath: "", releaseDate: "", overview: "", runtime: nil, genres: nil, voteAverage: 0, backdropPath: "", language: "")])
            handler(.success(mockResponse as! T))
        }
    }
    
    func fetchMoviePoster(posterPath: String, handler: @escaping (Data) -> Void) {
        if shouldReturnErrorForPoster {
            print("Mock error occurred while fetching poster")
            handler(Data(repeating: 0, count: 0))
            return
        }
        
        let mockImageData = Data(repeating: 0, count: 1)
        handler(mockImageData)
    }
}
