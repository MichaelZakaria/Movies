//
//  ViewController.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let network = NetworkManager()
        network.getData(endPoint: .movieDetail(id: 957452), type: Movie.self) { result in
            switch result {
            case .success(let movie):
                print("movie detail: \(movie.title)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        network.getData(endPoint: .nowPlaying, type: MoviesResponse.self) { result in
            switch result {
            case .success(let moviesResponse):
                print("now playing: \(moviesResponse.results.first?.title ?? "not found")")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        network.getData(endPoint: .popular, type: MoviesResponse.self) { result in
            switch result {
            case .success(let moviesResponse):
                print("popular: \(moviesResponse.results.first?.title ?? "not found")")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        network.getData(endPoint: .upcoming, type: MoviesResponse.self) { result in
            switch result {
            case .success(let moviesResponse):
                print("upcoming: \(moviesResponse.results.first?.title ?? "not found")")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

