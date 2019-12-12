//
//  Globals.swift
//  Rightpoint
//
//  Created by Omar Ata on 12/11/19.
//  Copyright © 2019 AtaBytes. All rights reserved.
//

import UIKit
import Reachability

var safeAreaFrame = CGRect.zero
let reachability = try! Reachability()

private let apiKey = "e28ed83e"
private let urlBase = "https://www.omdbapi.com/?apikey=%@&s=%@&type=%@&page=%i"

//format the URL and encode it
func getURL(for title: String, type: String, page: Int) -> String {
    if let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        return String(format: urlBase, apiKey, encodedTitle, type, page)
    } else {
        return String(format: urlBase, apiKey, title, type, page)
    }
}
