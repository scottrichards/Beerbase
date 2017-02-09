//
//  BeerDetails.swift
//  BeerTracker
//
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

class BeerDetails: NSManagedObject {
  
  // Attributes
  @NSManaged var image: String?
  @NSManaged var note: String?
  @NSManaged var rating: NSNumber?
  
  // Relationships
  @NSManaged var beer: Beer
}
