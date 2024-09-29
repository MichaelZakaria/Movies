//
//  ListScreenViewController.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-27.
//

import UIKit

class ListScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var moviesTable: UITableView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: ListScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.moviesTable.delegate = self
        self.moviesTable.dataSource = self
        
        setupActivityIndicator()
        registerMovieTableViewCell()
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMovies()
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        loadMovies()
    }
    
    func setViewModel() {
        viewModel = ListScreenViewModel()
        viewModel?.bindResultToViewController = { error in
            
            self.activityIndicator.stopAnimating()
            self.refreshButton.isHidden = true
            self.notFoundLabel.isHidden = true
            
            if let error = error {
                self.showAlert(title: "⚠️", message: error.localizedDescription)
            } else {
                if self.viewModel?.movies.count ?? 0 > 0 {
                    self.moviesTable.reloadData()
                } else {
                    self.notFoundLabel.isHidden = false
                }
            }
        }
    }
    
    func registerMovieTableViewCell() {
        let movieCellNib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        moviesTable.register(movieCellNib, forCellReuseIdentifier: "movieCell")
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "retry", style: .default, handler: { action in
            self.loadMovies()
        }))
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            self.refreshButton.isHidden = false
        }))
        self.present(alert, animated: true)
    }
    
    func loadMovies() {
        switch self.tabBarItem.tag {
        case 0: // Now playing
            if let playing = viewModel?.playnig {
                    viewModel?.movies = playing
            } else {
                activityIndicator.startAnimating()
                viewModel?.loadMovies(endpoint: .nowPlaying)
            }
        case 1: // Popular
            if let popular = viewModel?.popular {
                viewModel?.movies = popular
            } else {
                activityIndicator.startAnimating()
                viewModel?.loadMovies(endpoint: .popular)
            }
        case 2: // Upcoming
            if let upcoming = viewModel?.upcoming {
                viewModel?.movies = upcoming
            } else {
                activityIndicator.startAnimating()
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
        
        if let cachedImage = ImageCache.shared.object(forKey: (viewModel?.movies[indexPath.row].posterPath ?? "") as NSString) {
            cell.moviePoster.image = cachedImage
        } else {
            cell.moviePoster.image = UIImage(named: "movie_3")
            viewModel?.loadMoviePoster(posterPath: viewModel?.movies[indexPath.row].posterPath ?? "", handler: { data in
                if let posterImage = UIImage(data: data) {
                    ImageCache.shared.setObject(posterImage, forKey: (self.viewModel?.movies[indexPath.row].posterPath ?? "") as NSString)
                    cell.moviePoster.image = posterImage
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "movieDetails") as! MovieDetailsTableViewController
        movieDetailsVC.id = viewModel?.movies[indexPath.row].id
        movieDetailsVC.name = viewModel?.movies[indexPath.row].title
        movieDetailsVC.poster = (moviesTable.cellForRow(at: indexPath) as! MovieTableViewCell).moviePoster.image
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
