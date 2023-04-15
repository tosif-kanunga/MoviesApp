//
//  MovielListViewController.swift
//  Movies
//
//  Created by shadab sheikh on 2023-04-13.
//

import UIKit

class MovieListViewController: UIViewController {
    // MARK: IBAction
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var noInternetView: UIView!
    // MARK: Properties
    lazy var viewModel: MoviesListViewModel = {
        let viewModel = MoviesListViewModel()
        return viewModel
    }()
    var movieList = [MoviesData]()
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var didEndReached:Bool=false
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieListData(page: 1)
    }
    // MARK: Button action
    @IBAction func retryButtonAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            noInternetView.isHidden = true
            movieCollectionView.isHidden = false
            fetchMovieListData(page: 1)
        } else {
            noInternetView.isHidden = false
            movieCollectionView.isHidden = true
            print("Internet Connection not Available!")
        }
    }
    @IBAction func didTappedLikeMovieButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavoritesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
extension MovieListViewController {
    // Api callng for fetch movies from server
    func fetchMovieListData(page: Int) {
        if Reachability.isConnectedToNetwork(){
            
            viewModel.fetchMoviesList(page: pageNo) { responce, status, msg in
                if status {
                    for menuObject in responce {
                        let menuModel = MoviesData(dataObject: menuObject)
                        self.movieList.append(menuModel)
                    }
                    DispatchQueue.main.async {
                        self.movieCollectionView.reloadData()
                    }
                } else {
                    
                }
            }
            self.noInternetView.isHidden = true
            self.movieCollectionView.isHidden = false
            print("Internet Connection Available!")
        } else {
            self.noInternetView.isHidden = false
            self.movieCollectionView.isHidden = true
            print("Internet Connection not Available!")
        }
    }
    
    // MARK: Pagination
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if ((movieCollectionView.contentOffset.y + movieCollectionView.frame.size.height) >= movieCollectionView.contentSize.height) {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                fetchMovieListData(page: self.pageNo)
            }
        }
    }
}
