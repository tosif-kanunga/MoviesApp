//
//  NetworkManager.swift
//  Movies
//
//  Created by shadab sheikh on 2023-04-13.
//

import Foundation

class NetworkManager: NSObject {
    class func showActivityIndicator() {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 120
        config.spinnerColor = .black
        config.foregroundColor = .black
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config: config)
        SwiftLoader.show(title: "Loading...", animated: true)
    }
    
    class func hideActivityIndicator() {
        SwiftLoader.hide()
    }
    class func fetchMovies(page:Int ,completionHandler: @escaping (_ responce: [[String: Any]], Bool, String)->Void) {
        showActivityIndicator()
        guard let gitUrl = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=34c902e6393dc8d970be5340928602a7&page=\(page)") else { return }
        print(gitUrl)
        let request = NSMutableURLRequest(url: gitUrl)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: [:], options: [])
        let _: Void = session.dataTask(with: request as URLRequest) { data, response, error in
            hideActivityIndicator()
            guard let data = data else { return }
            
            let JSONString = String(data: data, encoding: .utf8)
            let jsonData = JSONString?.data(using: .utf8)!
            do {
                // make sure this JSON is in the format we expect
                // convert data to json
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a dictionary
                    print(json)
                    if let data = json["results"] as? [[String:Any]] {
                        completionHandler(data, true, "")
                    }
                }
            }
            catch {
                hideActivityIndicator()
                print (error)
                completionHandler([[:]], false, "Something went wrong..")
            }            
        }.resume()
    }
}

