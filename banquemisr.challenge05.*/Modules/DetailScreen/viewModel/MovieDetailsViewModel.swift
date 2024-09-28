//
//  MovieDetailsViewModel.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-28.
//

import Foundation

class MovieDetailsViewModel{
    
    let network: NetworkManagerProtocol
    
    var bindResultToViewController: (() -> Void) = {}
    
    var movie: Movie? {
        didSet {
            //loadMovieDetails()
            bindResultToViewController()
        }
    }
    
    init() {
        self.network = NetworkManager()
    }
    
    func fetchMovieDetails(id: Int) {
        network.getData(endPoint: .movieDetail(id: id), type: Movie.self) { result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    self.movie = movie
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadBackdrop(backdropPath: String, handler: @escaping (_ data: Data) -> Void) {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")!

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
