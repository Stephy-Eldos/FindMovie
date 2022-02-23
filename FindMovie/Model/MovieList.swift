//
//  MovieList.swift
//  FindMovie
//
//  Created by VARGHESE Stephy on 22/2/22.
//

import Foundation
import UIKit

struct MovieList {
    var movieName: String?
    var year: String?
    var imdbID: String?
    var imagePath: String?
    
    mutating func initWithDict(dict:NSDictionary)  {
        movieName = dict["Title"] != nil ? dict["Title"] as! String: ""
        year = dict["Year"] != nil ? dict["Year"] as! String: ""
        imdbID = dict["imdbID"] != nil ? dict["imdbID"] as! String: ""
        imagePath = dict["Poster"] != nil ? dict["Poster"] as! String: ""
    }
}

extension MovieList: ImageRepresentable {
    var image: UIImage? {
        get {
            var returnVal: UIImage? = nil
            
            if returnVal == nil, let imagePath = imagePath {
                returnVal = UIImage(named: imagePath)
            }
            
            return returnVal
        }
        
        set {
            
        }
    }
}

protocol ImageRepresentable {
    var image: UIImage? { mutating get set }
}

