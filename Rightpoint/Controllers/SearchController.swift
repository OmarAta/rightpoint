//
//  SearchController.swift
//  Rightpoint
//
//  Created by Omar Ata on 12/11/19.
//  Copyright © 2019 AtaBytes. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher

class SearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchOMDBDelegate {

    var shows = [Show]()
    var searchTitle = ""
    var searchType  = ""
    
    //UI Elements
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var noResultsView: UIView!
    @IBOutlet var loadingView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //double check that searchTitle was set
        if (searchTitle == "") {
            showNoResults()
        } else {
            //show loading view till we get a result from data fetching
            showLoadingView()
            
            //initiate the data fetching from OMDB
            SearchOMDB(self).fetchData(title: searchTitle, type: searchType)
        }
    }
    
    //MARK:- Fetch Data Functions
    func fetchDataNewResults(_ results: [Show]) {
        //we got something, hide loadingView
        hideLoadingView()
        
        if (results.count == 0 && shows.count == 0) {
            //show "No Results" view
            showNoResults()
        } else {
            //append all the new results to the shows array
            shows += results
            
            //reload the collection view data source
            collectionView.reloadData()
        }
    }
    
    //MARK:- Collection View Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        title = "\(searchTitle) (\(shows.count))"
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //adjust the cell width to half the screen
        return CGSize(width: view.frame.width/2, height: 280)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCell
        
        //bind array value to UI
        cell.title.text = shows[indexPath.row].title
        cell.year.text  = shows[indexPath.row].year
        
        cell.title.sizeToFit()
        
        //asynchronsly load the image from the URL
        if let url = URL(string: shows[indexPath.row].poster) {
            let processor = RoundCornerImageProcessor(cornerRadius: 4)

            //Kingfisher takes care of caching and retrieving previously loaded images
            cell.poster.kf.setImage(
            with: url,
            placeholder: UIImage(named: "show_default"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        }

        return cell
    }
    
    //MARK:- UI Functions
    func showNoResults() {
        noResultsView.frame = view.frame
        view.addSubview(noResultsView)
    }
    
    func showLoadingView() {
        loadingView.animation = Animation.named("loading")
        loadingView.frame     = safeAreaFrame
        loadingView.loopMode  = .loop
        loadingView.play()
        
        view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
        loadingView.stop()
    }
}
