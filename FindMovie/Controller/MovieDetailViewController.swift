//
//  MovieDetailViewController.swift
//  FindMovie
//
//  Created by VARGHESE Stephy on 23/2/22.
//

import UIKit
import Alamofire

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var labelrunTime: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var labelReleased: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var textViewSynopsis: UITextView!
    @IBOutlet weak var labelAwards: UILabel!
    @IBOutlet weak var labelWriter: UILabel!
    @IBOutlet weak var labelDirector: UILabel!
    @IBOutlet weak var labelActors: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var imageViewPlayButton: UIImageView!
    @IBOutlet weak var viewOrange: UIView!
    var movieList = MovieList()
    var movieModal = MovieModel()
    let url = "https://www.omdbapi.com/?apikey=b9bd48a6"
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUp()
    }
    
    //MARK: - SetUp Methods
    func setUp() {
        self.navigationController?.navigationBar.isHidden = true
        fetchImdbID(ID: movieList.imdbID ?? "")
        imageViewPlayButton.layer.cornerRadius = imageViewPlayButton.frame.size.width/2
        imageViewPlayButton.layer.masksToBounds = true
    }
    
    func fetchImdbID(ID: String) {
        let movieUrl = "\(url)&i=\(ID)"
        performRequest(with: movieUrl)
    }
    
    //MARK: - Data Manipulation Methods
    func performRequest(with urlString: String) {
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success:
                let responseStatus = (response.value as? NSDictionary)?["Response"] as? String
                if responseStatus == "True" {
                if let movieDetails = response.value as? NSDictionary {
                    self.movieModal.initWithDict(dict: movieDetails)
                    self.displayMovieDetails()
                }

                } else {
                    print("No Data Found")
                }
            case .failure(_):
                break
            }
        }
    }
    
    func displayMovieDetails() {
        LabelTitle.text = movieModal.Title
        labelMovieName.text = movieModal.Title
        labelYear.text = movieModal.Year
        labelrunTime.text = movieModal.Runtime
        labelLanguage.text = movieModal.Language
        labelGenre.text = movieModal.Genre
        labelReleased.text = movieModal.Released
        labelRating.text = movieModal.imdbRating
        labelDirector.text = "Director: \(movieModal.Director ?? "")"
        labelWriter.text = "Writer: \(movieModal.Writer ?? "")"
        labelActors.text = "Actors: \(movieModal.Actors ?? "")"
        labelAwards.text = "Awards: \(movieModal.Awards ?? "")"
        textViewSynopsis.text = movieModal.Plot
        if let url = URL(string: (movieModal.Poster)!) {
            let data = try? Data(contentsOf: url)
            if let imageData = data {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.imageViewPoster.image = image
                }
            }
        }
    }
    
    //MARK: - IB Action
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
