//
//  MovieTableViewCell.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-27.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
