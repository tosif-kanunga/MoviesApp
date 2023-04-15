//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by shadab sheikh on 2023-04-14.
//

import UIKit
import Kingfisher
import CoreData

class MovieDetailsViewController: UIViewController {
    // MARK: IBAction
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    // MARK: Properties
    var movieDetails = MoviesData(dataObject: [:])
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        likeButton.setImage(UIImage(named: "dislike"), for: .normal)
        DispatchQueue.main.async { [self] in
            if movieDetails.poster_path == nil {
                movieImage.image = UIImage(data: movieDetails.stored_path ?? Data())
            } else {
                if let url = URL(string: "https://image.tmdb.org/t/p/original"+(movieDetails.poster_path ?? "")) {
                    movieImage.kf.setImage(with: url)
                }
            }
            movieNameLabel.text = movieDetails.title
            overViewLabel.text = movieDetails.overview
            otherLabel.text = "TMDB Rating: \(movieDetails.vote_average ?? 0.0)\n\nRelease Date: \(movieDetails.release_date ?? "")\n\nLanguage: \(movieDetails.original_language ?? "")"
        }
        someEntityExists(original_title: movieDetails.original_title ?? "")
    }
    // MARK: Button action
    @IBAction func didTappedLikeButtonAction(_ sender: Any) {
        if likeButton.currentImage == UIImage(named: "dislike") {
            likeButton.setImage(UIImage(named: "like"), for: .normal)
            
            CoreDataManager.shared.createData(movies: movieDetails, store_path: movieImage.image?.pngData() ?? Data())
        } else {
            CoreDataManager.shared.deleteData(original_title: movieDetails.original_title ?? "")
            likeButton.setImage(UIImage(named: "dislike"), for: .normal)
        }
        NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)

        likeAnimation()
    }
    //Checking movie existing or not
    func someEntityExists(original_title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        fetchRequest.predicate = NSPredicate(format: "original_title = %@", original_title )
        var results: [NSManagedObject] = []
        do {
            results = try managedContext.fetch(fetchRequest)
        } catch {
            print("error executing fetch request: \(error)")
        }
        if results.count > 0 {
            likeButton.setImage(UIImage(named: "like"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "dislike"), for: .normal)
        }
    }
    // Pop animation for like button
    func likeAnimation() {
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.likeButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.likeButton.transform = CGAffineTransform.identity
            }
        })
    }
}
