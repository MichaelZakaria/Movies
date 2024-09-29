//
//  MovieDetailTableViewController.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-28.
//

import UIKit

class MovieDetailsTableViewController: UITableViewController {
    
    var id: Int?
    var name: String?
    var poster: UIImage?
    
    var viewModel: MovieDetailsViewModel?
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var moviePoster: CustomImageView!
    @IBOutlet weak var movieOverview: UILabel!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = .init(top: 50, left: 0, bottom: -30, right: 0)
        
        setActivityIndicator()
        setNavigationBar()
        setbackGroundImage(image: poster!)
        
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMovie()
    }
    
    func setViewModel() {
        viewModel = MovieDetailsViewModel()
        
        viewModel?.bindResultToViewController = { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                showAlert(title: "⚠️", message: error.localizedDescription)
                self.activityIndicator.stopAnimating()
                return
            }
            
            if let movie = viewModel?.movie {
                activityIndicator.stopAnimating()
                setMovieDetailsUI(movie: movie)
                tableView.reloadData()
            } else {
                showAlert(title: "⚠️", message: "Somethong went wrong please try again")
            }
        }
            
    }
    
    func loadMovie() {
        if viewModel?.movie == nil {
            activityIndicator.startAnimating()
            viewModel?.fetchMovieDetails(id: id ?? 0)
        } else {
            viewModel?.bindResultToViewController(nil)
        }
    }
    
    func setMovieDetailsUI(movie: Movie) {
        moviePoster.image = poster
        movieTitle.text = name
        movieOverview.text = movie.overview
        if movie.runtime == 0 {
            movieRuntime.text = "Unknown"
            minuteLabel.isHidden = true
            minuteLabel.text = .none
        } else {
            movieRuntime.text = movie.runtime?.description
        }
        movieGenres.text = movie.genres?.reduce("") { (partialResult, genre) in
            if movie.genres?.first?.id == genre.id {
                return "\(genre.name)"
            } else {
                return "\(partialResult ?? "") - \(genre.name)"
            }
        }
        movieScore.text = movie.voteAverage == 0.0 ? "Not scored yet" : String(format: "%.1f", movie.voteAverage)
        movieLanguage.text = movie.language
        movieReleaseDate.text = movie.releaseDate
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func setActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
    }
    
    func setNavigationBar() {
        self.title = name ?? ""
        self.navigationController?.navigationBar.tintColor = UIColor(.black)
    }
    
    func setbackGroundImage(image: UIImage) {
        let backgroundImageView = UIImageView()
        let backgroundImage = blurImage(image: image, brightnessAmount: 0.05, radius: 50)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = true
        // Add the image view to the table view's background
        tableView.backgroundView = backgroundImageView
    }
    
    func blurImage(image: UIImage, brightnessAmount: CGFloat, radius: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        // Create a filter for brightness adjustment
        let brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        brightnessFilter?.setValue(brightnessAmount, forKey: kCIInputBrightnessKey)
        
        guard let brightenedCIImage = brightnessFilter?.outputImage else { return nil }
        
        // Create a filter for Gaussian blur
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(brightenedCIImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputCIImage = blurFilter?.outputImage else { return nil }
        
        let context = CIContext()
        
        // Get the image size
        let size = image.size
        let rect = CGRect(origin: .zero, size: size)
        
        // Create a CGImage from the output CIImage using the original size
        guard let cgImage = context.createCGImage(outputCIImage, from: rect) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.movie != nil ? 8 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
