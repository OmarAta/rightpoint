//
//  MainController.swift
//  Rightpoint
//
//  Created by Omar Ata on 12/11/19.
//  Copyright © 2019 AtaBytes. All rights reserved.
//

import UIKit
import Kingfisher
import Reachability

class MainController: UIViewController {

    @IBOutlet weak var searchTitle: UITextField!
    @IBOutlet weak var searchType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        //clean any cached images from last search
        ImageCache.default.clearMemoryCache()
    
        //setup a reachability notifier to detect connectivity changes
         NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
          try? reachability.startNotifier()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
    }

    @IBAction func search(_ sender: UIButton) {
        //dismiss the keyboard
        searchTitle.resignFirstResponder()
        
        //trim any unwanted white spaces
        searchTitle.text = searchTitle.text?.trimmingCharacters(in: .whitespaces)
        
        if (searchTitle.text?.isEmpty ?? true) {
            shakeSearchTitle()
        } else {
            performSegue(withIdentifier: "SearchSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SearchSegue") {
            if let searchTitle = searchTitle.text {
                let vc = segue.destination as! SearchController
                vc.title = searchTitle
                vc.searchTitle = searchTitle
                
                //set the search type
                //by default it is empty string in the destination VC
                if(searchType.selectedSegmentIndex == 0) {
                    vc.searchType = "movie"
                } else if(searchType.selectedSegmentIndex == 1) {
                    vc.searchType = "series"
                }
            }
        }
    }
    
    //MARK:- UI Functions
    func shakeSearchTitle() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: searchTitle.center.x - 10, y: searchTitle.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: searchTitle.center.x + 10, y: searchTitle.center.y))

        searchTitle.layer.add(animation, forKey: "position")
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability

        if (reachability.connection == .unavailable) {
            //stop the notifier
            reachability.stopNotifier()

            //device is offline
            performSegue(withIdentifier: "OfflineSegue", sender: self)
        }
    }
}

