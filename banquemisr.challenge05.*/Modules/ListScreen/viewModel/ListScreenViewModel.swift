//
//  ListScreenViewModel.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-27.
//

import Foundation

class ListScreenViewModel {
    
    let network: NetworkManagerProtocol
    
    var bindResultToViewController: (() -> Void) = {}
    
    var movies: [Movie] = []
    
    var playnig: [Movie] = []
    var popular: [Movie] = []
    var upcoming: [Movie] = []
    
    init() {
        self.network = NetworkManager()
    }
    
    func loadMovies(endpoint: EndPoints) {
        network.getData(endPoint: endpoint, type: MoviesResponse.self) { result in
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
                    print("\(endpoint): \(moviesResponse.results.first?.title ?? "not found")")
                    self.movies = moviesResponse.results
                    self.bindResultToViewController()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMoviePoster(posterPath: String, handler: @escaping (_ data: Data) -> Void) {
        
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!

        let imageTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {return}
            
            print("done")
            
            DispatchQueue.main.async {
                handler(data)
            }
        }
        imageTask.resume()
    }
}
