//
//  Show.swift
//  Rightpoint
//
//  Created by Omar Ata on 12/11/19.
//  Copyright © 2019 AtaBytes. All rights reserved.
//

import Foundation
import Kingfisher

class Show: NSObject {
    let title: String
    let year: String
    let poster: String
    
    init(title: String, year: String, poster: String) {
        self.title  = title
        self.year   = year
        self.poster = poster
    }
}
