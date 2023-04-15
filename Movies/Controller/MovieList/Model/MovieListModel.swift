//
//  MovieListModel.swift
//  Movies
//
//  Created by shadab sheikh on 2023-04-13.
//

import Foundation

struct MoviesData {
    var adult : Bool?
    var id : Int?
    var original_language : String?
    var original_title: String?
    var overview : String?
    var popularity : Double?
    var poster_path: String?
    var stored_path: Data?
    var release_date : String?
    var title : String?
    var video : Int?
    var vote_average : Float?
    var vote_count: Int?
    var like: Bool = false
    
    init(dataObject: [String:Any]) {
        if let adult = dataObject["adult"] as? Bool {
            self.adult = adult
        }
        if let id = dataObject["id"] as? Int {
            self.id = id
        }
        if let original_language = dataObject["original_language"] as? String {
            self.original_language = original_language
        }
        if let original_title = dataObject["original_title"] as? String {
            self.original_title = original_title
        }
        if let overview = dataObject["overview"] as? String {
            self.overview = overview
        }
        if let popularity = dataObject["popularity"] as? Double {
            self.popularity = popularity
        }
        if let poster_path = dataObject["poster_path"] as? String {
            self.poster_path = poster_path
        }
        if let release_date = dataObject["release_date"] as? String {
            self.release_date = release_date
        }
        if let title = dataObject["title"] as? String {
            self.title = title
        }
        if let video = dataObject["video"] as? Int {
            self.video = video
        }
        if let vote_average = dataObject["vote_average"] as? Float {
            self.vote_average = vote_average
        }
        if let vote_count = dataObject["vote_count"] as? Int {
            self.vote_count = vote_count
        }
    }
}

 
 
 
