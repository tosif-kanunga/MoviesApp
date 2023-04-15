//
//  FavouriteViewController.swift
//  Movies
//
//  Created by shadab sheikh on 2023-04-15.
//

import UIKit
import CoreData
class FavoritesViewController: UIViewController {
    // MARK: IBAction
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var noDatafound: UIView!

    // MARK: Properties
    lazy var viewModel: MoviesListViewModel = {
        let viewModel = MoviesListViewModel()
        return viewModel
    }()
    var movieList = [MoviesData]()
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        fetchDataFromDataBase()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(notification:)), name: Notification.Name("reloadData"), object: nil)
    }
    // Reload data through notification
    @objc func reloadData(notification: Notification) {
        fetchDataFromDataBase()
    }
    // MARK: Button Action
    @IBAction func didTappedBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(cellData: movieList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = movieCollectionView.frame.size
        return CGSize(width: size.width/2.1, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.movieDetails = movieList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoritesViewController {
    // Fetch data from coredata-base
    func fetchDataFromDataBase() {
        CoreDataManager.shared.retrieveData(completionHandler: { response in
            self.movieList.removeAll()
            self.movieList = response
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
            if self.movieList.count > 0 {
                self.noDatafound.isHidden = true
                self.movieCollectionView.isHidden = false
            } else {
                self.noDatafound.isHidden = false
                self.movieCollectionView.isHidden = true
            }
        })
    }
}
