//
//  NetworkManager.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-26.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData<T: Codable>(endPoint: EndPoints, type: T.Type, handler: @escaping (Result<T, Error>) -> Void)
    func fetchMoviePoster(posterPath: String, handler: @escaping (_ data: Data) -> Void)
}

enum EndPoints {
    case nowPlaying
    case popular
    case upcoming
    case movieDetail(id:Int)
    case movieVideos(id:Int)
    var rawValue: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .upcoming:
            return "upcoming"
        case .movieDetail(id: let id):
            return "\(id)"
        case .movieVideos(id: let id):
            return "\(id)/videos"
        }
    }
}

class NetworkManager: NetworkManagerProtocol{
    func fetchData<T: Codable>(endPoint: EndPoints, type: T.Type, handler: @escaping (Result<T, Error>) -> Void) {
        // 1
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint.rawValue)")
        // 2
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZTExNGEzMTc5ODA2NWQ5OWY4MWFhY2E2OGZhM2E2NSIsIm5iZiI6MTcyNzM4MDcyOS40MTk2OCwic3ViIjoiNjZmNWI5YTllZmNjMGFlOTBkYmVkZmY5Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.Swb6NY880b2gzBunwINcKdGPXLTtcDNx6UyuzUq8tPk"
        ]
        // 3
        let session = URLSession(configuration: URLSessionConfiguration.default)
        // 4
        let task = session.dataTask(with: request) { data, response, error in
            // 6
            // Check for errors
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Ensure there's data
            guard let data = data else {
                handler(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let movie = try JSONDecoder().decode(T.self, from: data)
                handler(.success(movie))
            } catch {
                handler(.failure(error))
            }
            
        }
        // 5
        task.resume()
    }
    
    func fetchMoviePoster(posterPath: String, handler: @escaping (_ data: Data) -> Void) {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!

        let imageTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {return}
            //print("done")
            DispatchQueue.main.async {
                handler(data)
            }
        }
        imageTask.resume()
    }
}
