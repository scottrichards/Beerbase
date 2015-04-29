//
//  Beer.swift
//  BeerTracker
//
//  Created by Ed on 4/28/15.
//  Copyright (c) 2015 Anros Applications, LLC. All rights reserved.
//

import Foundation
import CoreData

// This directive makes the class accessible to Objective-C code from the MagicalRecord library.
@objc(Beer)

class Beer: NSManagedObject {

  // Attributes
  @NSManaged var name: String
  
  // Relationships
  @NSManaged var beerDetails: BeerDetails
}
