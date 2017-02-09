//
//  Functions.swift
//  BeerTracker
//
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import Foundation

//#####################################################################
// MARK: - Public Global Constants

//         Only a single instance is ever created (to conserve execution time and battery power).
//         The code is run only the very first time the object is needed in the app (a.k.a. lazy loading).
//         "Global" constants can be used outside of this Swift file since they do not belong to a class.

// Assign to a global constant a path to the app's Documents directory.
let applicationDocumentsDirectory: String = {
  let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) 
  return paths[0]
  
  // Using "()" after the Closure to assign the result of the closure code to applicationDocumentsDirectory.
  // Omitting "()" would assign the block of code itself to applicationDocumentsDirectory.
  }()
