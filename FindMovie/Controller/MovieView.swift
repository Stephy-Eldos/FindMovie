//
//  MovieView.swift
//  FindMovie
//
//  Created by VARGHESE Stephy on 22/2/22.
//

import Foundation
import UIKit


class MovieView: UIView {
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    var items = [MovieListCellItem]()
    var movieListItems = [MovieList]()
    
    init() {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    func reloadData() {
        collectionView.reloadData()
    }
}

extension MovieView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieListCollectionViewCell
        let item = items[indexPath.row]
        cell.tintColor = tintColor
        cell.item = item
        return cell
    }
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.action?(item)
    }
    
    //MARK: CollectionViewFlow Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = items[indexPath.row]
        return CGSize(width: item.width, height: item.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

struct MovieListCellItem {
    var width: CGFloat = 1.0
    var height: CGFloat = 1.0
    var action: ((_ item: MovieListCellItem) -> Void)? = nil
    var movieList: MovieList
}


class MovieListCollectionViewCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    private var labelTitle = UILabel()
    private var labelYearValue = UILabel()
    private var underlineView = UIView()
    
    var item: MovieListCellItem? {
        didSet {
            DispatchQueue.global(qos: .userInitiated).async {
                if let urlString = self.item?.movieList.imagePath {
                    let urlFromString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    if urlFromString!.hasPrefix("https://") {
                        if let url = URL(string: urlFromString!) {
                        let data = try? Data(contentsOf: url)
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                        }
                    }
                }
            }
            }
            labelTitle.text = item?.movieList.movieName ?? "Movie"
            labelYearValue.text = "\(item?.movieList.year ?? " ")"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func action(sender: UIButton) {
        
    }
    
    private func setUp() {
        addSubview(imageView)
        addSubview(labelTitle)
        addSubview(labelYearValue)
        addSubview(underlineView)
        
        labelTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        labelYearValue.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        labelTitle.adjustsFontSizeToFitWidth = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelYearValue.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        underlineView.backgroundColor = UIColor.lightGray
        labelYearValue.textColor = UIColor.brown
        
        imageView.image = item?.movieList.image
        labelTitle.text = item?.movieList.movieName
        labelTitle.numberOfLines = 0
        labelYearValue.text = "\(item?.movieList.year ?? " ")"
        
        let views: [String: Any] = [
            "imageView": imageView,
            "labelTitle": labelTitle,
            "labelYearValue": labelYearValue,
            "underlineView": underlineView]
        
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-8-[imageView]-4-[labelTitle(40)]-1-[underlineView(1)]-0-|",
            metrics: nil,
            views: views)
        
        let horizontalImageViewConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-8-[imageView]-8-|",
            metrics: nil,
            views: views)
        
        let horizontalLabelTitleConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-8-[labelTitle]-4-[labelYearValue(40)]-8-|",
            metrics: nil,
            views: views)
        
        let horizontalUnderlineConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-8-[underlineView]-8-|",
            metrics: nil,
            views: views)
        
        allConstraints += verticalConstraints
        allConstraints += horizontalImageViewConstraints
        allConstraints += horizontalLabelTitleConstraints
        allConstraints += horizontalUnderlineConstraints
        
        NSLayoutConstraint.activate(allConstraints)
        
        labelYearValue.topAnchor.constraint(equalTo: labelTitle.topAnchor).isActive = true
    }
    
}

