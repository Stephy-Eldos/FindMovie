//
//  MovieModel.swift
//  FindMovie
//
//  Created by VARGHESE Stephy on 22/2/22.
//

import Foundation


struct MovieModel {
    var Title: String?
    var Year: String?
    var Released: String?
    var Runtime: String?
    var Genre: String?
    var Director: String?
    var Writer: String?
    var Language: String?
    var Actors: String?
    var Awards: String?
    var Plot: String?
    var Poster: String?
    var imdbRating: String?
    
    mutating func initWithDict(dict:NSDictionary)  {
        Title = dict["Title"] != nil ? dict["Title"] as! String: ""
        Year = dict["Year"] != nil ? dict["Year"] as! String: ""
        Released = dict["Released"] != nil ? dict["Released"] as! String: ""
        Runtime = dict["Runtime"] != nil ? dict["Runtime"] as! String: ""
        Genre = dict["Genre"] != nil ? dict["Genre"] as! String: ""
        Director = dict["Director"] != nil ? dict["Director"] as! String: ""
        Writer = dict["Writer"] != nil ? dict["Writer"] as! String: ""
        Language = dict["Language"] != nil ? dict["Language"] as! String: ""
        Actors = dict["Actors"] != nil ? dict["Actors"] as! String: ""
        Awards = dict["Awards"] != nil ? dict["Awards"] as! String: ""
        Plot = dict["Plot"] != nil ? dict["Plot"] as! String: ""
        Poster = dict["Poster"] != nil ? dict["Poster"] as! String: ""
        imdbRating = dict["imdbRating"] != nil ? dict["imdbRating"] as! String: ""
    }
}
