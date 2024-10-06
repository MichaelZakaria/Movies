//
//  ListScreenViewModel.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-27.
//

import Foundation

class ListScreenViewModel {
    
    let network: NetworkManagerProtocol
    
    var bindResultToViewController: ((_ error: Error?) -> Void) = {error in }
    
    var movies: [Movie] = []
    
    var playnig: [Movie]?
    var popular: [Movie]?
    var upcoming: [Movie]? 
    
    init() {
        self.network = NetworkManager()
    }
    
    func loadMovies(endpoint: EndPoints) {
        network.fetchData(endPoint: endpoint, type: MoviesResponse.self) { result in
            switch result {
            case .success(let moviesResponse):
                DispatchQueue.main.async {
                    switch endpoint {
                    case .nowPlaying:
                        self.playnig = moviesResponse.results
                    case .popular:
                        self.popular = moviesResponse.results
                    case .upcoming:
                        self.upcoming = moviesResponse.results
                    default:
                        return
                    }
                    //print("\(endpoint): \(moviesResponse.results.first?.title ?? "not found")")
                    self.movies = moviesResponse.results
                    self.bindResultToViewController(nil)
                }
            case .failure(let error):
                //print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.bindResultToViewController(error)
                }
            }
        }
    }
    
    func loadMoviePoster(posterPath: String, handler: @escaping (_ data: Data) -> Void) {
        network.fetchMoviePoster(posterPath: posterPath, handler: handler)
    }
}
