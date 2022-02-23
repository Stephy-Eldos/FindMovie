//
//  ViewController.swift
//  FindMovie
//
//  Created by VARGHESE Stephy on 22/2/22.
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController {

    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var movieView: MovieView!
    @IBOutlet weak var imageViewLaunch: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    var movieListCellItems = [MovieListCellItem]()
    var movieList = MovieList()
    var movieListItems = [MovieList]()
    var onMovieListItemTapped: ((_ item: MovieListCellItem) -> Void)?
    var searchedName = String()
    let url = "https://www.omdbapi.com/?apikey=b9bd48a6&type=movie"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //MARK: - SetUp Methods
    func setUp() {
        setUpMovieListItems(movieListArray: movieListItems)
        setUpCallbacks()
        textFieldSearch.delegate = self
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpMovieListItems(movieListArray: [MovieList]) {
        let cellItemWidth = UIScreen.main.bounds.width/2
        let cellItemHeight = UIScreen.main.bounds.width/2 + 60
        
        movieListCellItems = [MovieListCellItem]()
        
        for movie in movieListArray {
            movieListCellItems.append(MovieListCellItem(width: cellItemWidth, height: cellItemHeight, action: onMovieListItemTapped, movieList: movie))
        }
        movieView.items = movieListCellItems
        movieView.reloadData()
    }
    
    func  setUpCallbacks() {
        onMovieListItemTapped = { item in
            let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
            movieDetailVC?.movieList = item.movieList
            self.navigationController?.pushViewController(movieDetailVC!, animated: true)
        }
    }
    
    func fetchMovieName(movieName: String) {
        let movieUrl = "\(url)&s=\(movieName)"
        performRequest(with: movieUrl) {
            self.setUpMovieListItems(movieListArray: self.movieListItems)
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func performRequest(with urlString: String, completion: (() -> Void)! = nil) {
        movieListItems.removeAll()
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success:
                let responseStatus = (response.value as? NSDictionary)?["Response"] as? String
                if responseStatus == "True" {
                if let json = response.value as? NSDictionary {
                if let movieArray = json["Search"] as? NSArray {
                        if movieArray.count > 0 {
                            self.labelTitle.text = "Search results for '\(self.searchedName)'"
                            for i in 0...movieArray.count - 1 {
                                self.movieList.initWithDict(dict: movieArray[i] as! NSDictionary)
                            self.movieListItems.append(self.movieList)
                        }} else {
                            self.labelTitle.text = "No records found"
                        }
                }
                }
                    completion()
                } else {
                    self.labelTitle.text = "\((response.value as? NSDictionary)?["Error"] as? String ?? "No records found")"
                    completion()
                }
            case .failure(_):
                break
            }
        }
    }
}

//MARK: - UITextFieldDelegate Methods

extension MovieListViewController: UITextFieldDelegate {

    @IBAction func onSearchTapped(_ sender: UIButton) {
        if textFieldSearch.text != "" {
        textFieldSearch.endEditing(true)
        } else {
            textFieldSearch.placeholder = "Type Movie Name"
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldSearch.text != "" {
            textFieldSearch.resignFirstResponder()
            return true
        } else {
            textFieldSearch.placeholder = "Type Movie Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Search MovieName: \(textFieldSearch.text ?? "")")
        if let movie = textFieldSearch.text {
            searchedName = movie
            let refactoredMovie = movie.replacingOccurrences(of: " ", with: "_")
            fetchMovieName(movieName: refactoredMovie)
            imageViewLaunch.isHidden = true
        }
    }
}

