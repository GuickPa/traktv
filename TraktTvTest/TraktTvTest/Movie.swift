//
//  Movie.swift
//  TraktTvTest
//
//  Created by Guglielmo on 14/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//
//  GUI: Model class for Movie object

import UIKit

class Movie: NSObject {
    
    var title: NSString?
    var year: NSNumber?
    var overview: NSString?
    var infos: NSDictionary?
    
    init(info: NSDictionary!)
    {
        infos = NSDictionary(dictionary: info)
        title = infos!["title"] as? NSString
        year = infos!["year"] as? NSNumber
        overview = infos!["overview"] as? NSString
    }
}
