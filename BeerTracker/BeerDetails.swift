//
//  BeerDetails.swift
//  BeerTracker
//
//  Created by Ed on 4/28/15.
//  Copyright (c) 2015 Anros Applications, LLC. All rights reserved.
//

import Foundation
import CoreData

// This directive makes the class accessible to Objective-C code from the MagicalRecord library.
@objc(BeerDetails)

class BeerDetails: NSManagedObject {

  // Attributes
  @NSManaged var image: String
  @NSManaged var note: String
  @NSManaged var rating: NSNumber
  
  // Relationships
  @NSManaged var beer: Beer
}
