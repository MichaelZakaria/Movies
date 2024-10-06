//
//  MovieDetailsViewModel.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-28.
//

import Foundation

class MovieDetailsViewModel{
    
    let network: NetworkManagerProtocol
    
    var bindResultToViewController: ((_ error: Error?) -> Void) = {error in }
    
    var movie: Movie? {
        didSet {
            bindResultToViewController(nil)
        }
    }
    
    init() {
        self.network = NetworkManager()
    }
    
    func fetchMovieDetails(id: Int) {
        network.fetchData(endPoint: .movieDetail(id: id), type: Movie.self) { result in
            switch result {
            case .success(let movie):
                //print("ok")
                DispatchQueue.main.async {
                    self.movie = movie
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.bindResultToViewController(error)
                }
            }
        }
    }
    
    func fetchMovieVideos(id: Int, handler: @escaping (_ trailerUrl: URL?) -> Void) {
        network.fetchData(endPoint: .movieVideos(id: id), type: VideoResponse.self) { result in
            switch result {
            case .success(let videoResponse):
                DispatchQueue.main.async {
                    if let trailer = videoResponse.results.first(where: { video in
                        video.type == "Trailer"
                    }) {
                        handler(URL(string: "https://www.youtube.com/embed/\(trailer.key)"))
                    } else {
                        handler(nil)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    handler(nil)
                }
            }
        }
    }
}
