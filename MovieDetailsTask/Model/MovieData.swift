//
//  MovieData.swift
//  MovieDetailsTask
//
//  Created by Rashi Gambhir on 21/03/22.
//

import Foundation


struct MovieData: Codable{
    var Search: [SearchData]?
}

struct SearchData: Codable{
    let Title: String?
    let Poster: String?
    let Year: String?
    let `Type`: String?
    let imdbID : String?
    var flag : Bool? = false
    var typeImage: String {
        switch `Type`{
        case "movie":
            return "video"
        case "series":
            return "tv"
        default:
            return "underline"
        }
    }
}
