//
//  MovieDetailTableViewController.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-28.
//

import UIKit

class MovieDetailsTableViewController: UITableViewController {
    
    var id: Int?
    var poster: UIImage?
    
    var viewModel: MovieDetailsViewModel?
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var moviePoster: CustomImageView!
    @IBOutlet weak var movieOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = .init(top: 50, left: 0, bottom: -30, right: 0)
        
        setNavigationBar()
        
        setbackGroundImage(image: poster!)
        
        setViewModel()
    }
    
    func setViewModel() {
        viewModel = MovieDetailsViewModel()
        
        viewModel?.fetchMovieDetails(id: id ?? 0)
        
        viewModel?.bindResultToViewController = { [weak self] in
            guard let self = self else { return }
            // set movie title label
            self.title = viewModel?.movie?.title
            // set movie poster image
            moviePoster.image = poster
            // set movie overview label
            movieOverview.text = viewModel?.movie?.overview
            // set movie runtime label
            if viewModel?.movie?.runtime == 0 {
                movieRuntime.text = "Unknown"
                minuteLabel.isHidden = true
                minuteLabel.text = .none
            } else {
                movieRuntime.text = viewModel?.movie?.runtime?.description
            }
            // set movie genres label
            movieGenres.text = viewModel?.movie?.genres?.reduce("") { (partialResult, genre) in
                if self.viewModel?.movie?.genres?.first?.id == genre.id {
                    return "\(genre.name)"
                } else {
                    return "\(partialResult ?? "") - \(genre.name)"
                }
            }
            // set movie score label
            movieScore.text = viewModel?.movie?.voteAverage == 0.0 ? "Not scored yet" : String(format: "%.1f", viewModel?.movie?.voteAverage ?? 0.0)
            // set movie language label
            movieLanguage.text = viewModel?.movie?.language
            // set movie release date label
            movieReleaseDate.text = viewModel?.movie?.releaseDate
            
            tableView.reloadData()
        }
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor(.black)
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrowshape.turn.up.backward")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrowshape.turn.up.backward")
    }
    
    func setbackGroundImage(image: UIImage) {
        let backgroundImageView = UIImageView()
        let backgroundImage = blurImage(image: image, brightnessAmount: 0.05, radius: 50)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill // Adjust as needed
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
        return 7
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
