//
//  Beer.swift
//  BeerTracker
//
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

class Beer: NSManagedObject {
  
  // Attributes
  @NSManaged var name: String
  
  // Relationships
  @NSManaged var beerDetails: BeerDetails
}
