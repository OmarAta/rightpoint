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

private let urlBase = "https://www.omdbapi.com/?apikey=446f7e6e&s=%@&type=%@&page=%i"

//format the URL and encode it
func getURL(for title: String, type: String, page: Int) -> String {
    if let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        return String(format: urlBase, encodedTitle, type, page)
    } else {
        return String(format: urlBase, title, type, page)
    }
}
