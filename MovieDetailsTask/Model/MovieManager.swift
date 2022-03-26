//
//  MovieManager.swift
//  MovieDetailsTask
//
//  Created by Rashi Gambhir on 21/03/22.
//

import Foundation

class MovieManager{
    
    var completionHandler: ((MovieData) -> Void)?
    
    let movieUrl = "https://www.omdbapi.com/?apikey=fd12ab17"
    
    var s: String = "s"
    var page: String = "page"
    var apikey: String = "apikey"
    let key = "fd12ab17"
    var currentPage : Int = 0
    var isLoadingList : Bool = false
    
    func fetchMovie(movieName : String){
        var urlComponents = URLComponents()
        currentPage += 1
        self.isLoadingList = false
        urlComponents.scheme = "https"
        urlComponents.host = "omdbapi.com"
        urlComponents.queryItems = [
            URLQueryItem(name: s, value: movieName),
            URLQueryItem(name: apikey, value: key ),
            URLQueryItem(name: page, value: String(currentPage))
        ]
        //        let urlString = "\(movieUrl)&s=\()"
        performRequest(with: urlComponents.url!.absoluteString)
    }
    
    func performRequest(with urlString : String){
        
        // 1. Creating Url
        if let url = URL(string: urlString){
            // 2. create UrlSession
            let session = URLSession(configuration: .default)
            // 3. give session a task
            let task = session.dataTask(with: url) {data, response, error in
                
                if error != nil{
                    print("error in performing request")
                }
                
                if let safeData = data {
                    if let movie = self.parseJson(safeData){
                        self.completionHandler?(movie)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
        
    }
    func parseJson(_ movieData: Data) -> MovieData?{
        
        let decoder = JSONDecoder()
        do{
            var decodeData = try decoder.decode(MovieData.self, from: movieData)
            if let dataCount = decodeData.Search
            {
                for i in 0..<dataCount.count{
                    decodeData.Search?[i].flag = false
                }
            }
            return decodeData
        }
        catch{
            print("in catch")
            return nil
        }
    }
}
