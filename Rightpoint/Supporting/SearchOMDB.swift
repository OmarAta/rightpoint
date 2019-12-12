//
//  FetchData.swift
//  Rightpoint
//
//  Created by Omar Ata on 12/11/19.
//  Copyright © 2019 AtaBytes. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SearchOMDBDelegate {
    func fetchDataNewResults(_ results: [Show], page: Int, totalResults: Int)
}

class SearchOMDB: NSObject {
    
    var delegate: SearchOMDBDelegate
    
    init(_ delegate: SearchOMDBDelegate) {
        self.delegate = delegate
        super.init()
    }

    func fetchData(title: String, type: String, page: Int = 1) {
        DispatchQueue(label: "SearchOMDB.fetchData", qos: .background).async {
            var results = [Show]()
            var totalResults = 0
            
            //send the GET request
            Alamofire.request(getURL(for: title, type: type, page: page)).responseJSON { rawResponse in
                if let rawResponseData = rawResponse.result.value {
                    let response = JSON(rawResponseData)
                    
                    //check if "Response" is true
                    if (response["Response"].boolValue) {
                        //get the total number of results
                        totalResults = response["totalResults"].intValue

                        //get the "Search" JSON object
                        let shows = response["Search"].arrayValue
                        for show in shows {
                            results.append(Show(title: show["Title"].stringValue, year: show["Year"].stringValue, poster: show["Poster"].stringValue))
                        }
                    }
                }
                
                //inform the delegate about the new results
                self.delegate.fetchDataNewResults(results, page: page, totalResults: totalResults)
            }
        }
    }
}
