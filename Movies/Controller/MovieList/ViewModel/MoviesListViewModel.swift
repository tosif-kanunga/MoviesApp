//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by shadab sheikh on 2023-04-13.
//

import Foundation

struct MoviesListViewModel {
    func fetchMoviesList(page: Int, completionHandler: @escaping (_ responce: [[String: Any]], Bool, String)->Void) {
        NetworkManager.fetchMovies(page: page) { response,status,msg  in
            if status {
                completionHandler(response,status,msg)
            } else {
                completionHandler(response,status,msg)
            }
        }
    }
}
