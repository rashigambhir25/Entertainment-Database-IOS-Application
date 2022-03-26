//
//  DetailManager.swift
//  MovieDetailsTask
//
//  Created by Rashi Gambhir on 23/03/22.
//

import Foundation

class DetailManager{
    
    var completionHandler: ((DetailData) -> Void)?
    
    let detailUrl = "https://www.omdbapi.com/?apikey=fd12ab17"
    
    var i: String?
    var apikey: String = "apikey"
    let key = "fd12ab17"
    func fetchMovie(imdbID: String){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "omdbapi.com"
        urlComponents.queryItems = [
            URLQueryItem(name: i ?? "i", value: imdbID),
            URLQueryItem(name: apikey, value: key )
        ]
        if let url = urlComponents.url {
            performRequest(with: url)}
        
    }
    
    func performRequest(with url : URL){
        
        // 1. Creating Url
        //        if let url = URL(string: urlString){
        // 2. create UrlSession
        let session = URLSession(configuration: .default)
        // 3. give session a task
        let task = session.dataTask(with: url) {data, response, error in
            
            if error != nil{
                print("error in performing request")
            }
            
            if let safeData = data {
                if let detail = self.parseJson(safeData){
                    self.completionHandler?(detail)
                }
            }
        }
        // 4. Start the task
        task.resume()
        //        }
        
    }
    func parseJson(_ detailData: Data) -> DetailData?{
        
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(DetailData.self, from: detailData)
            return decodeData
        }
        catch{
            print("in catch")
            return nil
        }
    }
    
}
