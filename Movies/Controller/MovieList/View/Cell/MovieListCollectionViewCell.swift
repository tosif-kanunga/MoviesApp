//
//  MovieListCollectionViewCell.swift
//  Movies
//
//  Created by shadab sheikh on 2023-04-14.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    // MARK: IBAction
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    // MARK: Properties
    let mygroup = DispatchGroup()
    var activityIndicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 6.0
        cardView.layer.shadowOpacity = 0.7
    }
    func configureCell(cellData: MoviesData) {
        DispatchQueue.main.async { [self] in
            if cellData.poster_path == nil {
                movieImage.image = UIImage(data: cellData.stored_path ?? Data())
            } else {
                if let url = URL(string: "https://image.tmdb.org/t/p/original"+(cellData.poster_path ?? "")) {
                    movieImage.kf.indicatorType = .activity
                    movieImage.kf.setImage(with: url)
                }
            }
        }
    }
}

