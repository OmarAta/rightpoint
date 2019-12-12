//
//  OfflineController.swift
//  Rightpoint
//
//  Created by Omar Ata on 12/11/19.
//  Copyright © 2019 AtaBytes. All rights reserved.
//

import UIKit
import Lottie
import Reachability

class OfflineController: UIViewController {

    @IBOutlet weak var offlineView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offlineView.loopMode = .loop
        offlineView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setup a reachability notifier to detect connectivity changes
         NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
          try? reachability.startNotifier()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability

        if (reachability.connection != .unavailable) {
            //stop the notifier
            reachability.stopNotifier()
            
            //connectivity is back
            //dismiss this view controller
            self.dismiss(animated: true, completion: nil)
        }
    }
}
