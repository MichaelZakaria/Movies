//
//  ListScreenViewController.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-27.
//

import UIKit

class ListScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var moviesTable: UITableView!
    
    var viewModel: ListScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.moviesTable.delegate = self
        self.moviesTable.dataSource = self
        
        let movieCellNib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        moviesTable.register(movieCellNib, forCellReuseIdentifier: "movieCell")
        
        setViewModel()
    }
    
    func setViewModel() {
        viewModel = ListScreenViewModel()
        viewModel?.bindResultToViewController = {
            self.moviesTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch self.tabBarItem.tag {
        case 0:
            if viewModel?.playnig.count != 0 {
                viewModel?.movies = viewModel?.playnig ?? []
            } else {
                viewModel?.loadMovies(endpoint: .nowPlaying)
            }
        case 1:
            if viewModel?.popular.count != 0 {
                viewModel?.movies = viewModel?.popular ?? []
            } else {
                viewModel?.loadMovies(endpoint: .popular)
            }
        case 2:
            if viewModel?.upcoming.count != 0 {
                viewModel?.movies = viewModel?.upcoming ?? []
            } else {
                viewModel?.loadMovies(endpoint: .upcoming)
            }
        default:
            return
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTable.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        cell.movieName.text = viewModel?.movies[indexPath.row].title
        cell.releaseDate.text = viewModel?.movies[indexPath.row].releaseDate
        viewModel?.loadMoviePoster(posterPath: viewModel?.movies[indexPath.row].posterPath ?? "", handler: { data in
            cell.moviePoster.image = UIImage(data: data)
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }
}
