//
//  Movie+CoreDataProperties.swift
//  TraktTvTest
//
//  Created by Guglielmo on 15/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var title: String?
    @NSManaged var year: NSNumber?
    @NSManaged var overview: String?
    @NSManaged var index: NSNumber?
    @NSManaged var poster: String?
    @NSManaged var banner: String?

}
