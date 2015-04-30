//
//  ImageSaver.swift
//  BeerTracker
//
//  Created by Ed on 4/29/15.
//  Copyright (c) 2015 Anros Applications, LLC. All rights reserved.
//

import Foundation
import UIKit

class ImageSaver {
  
  //#####################################################################
  // MARK: - Save Image
  
  class func saveImageToDisk(image: UIImage, andToBeer beer: Beer) -> Bool {
    
    let imgData = UIImageJPEGRepresentation(image, 0.5)
    let name = NSUUID().UUIDString
    let fileName = "\(name).jpg"
    let pathName = applicationDocumentsDirectory.stringByAppendingPathComponent(fileName)
    
    //------------------------------------------
    if imgData.writeToFile(pathName, atomically: true) {
      
      beer.beerDetails.image = pathName
      
    } else {
      
      showImageSaveFailureAlert()
      return false
    }
    //------------------------------------------
    
    return true
  }
  //#####################################################################
  
  class func showImageSaveFailureAlert() {
    // This pops up an alert that notifies the user of an image save issue.
    
    let alert = UIAlertController(title: "Image Save Error",
                                message: "There was an error saving your photo. Try again.",
                         preferredStyle: .Alert)
    
    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    
    alert.presentViewController(alert, animated: true, completion: nil)
    alert.addAction(okAction)
  }
  //#####################################################################
  // MARK: - Delete Image
  
  class func deleteImageAtPath(path: String) {
    
    let fileManager = NSFileManager.defaultManager()
    
    // TODO: Might need to use pathName instead of path.
    //let pathName = applicationDocumentsDirectory.stringByAppendingPathComponent(path)
    
    if fileManager.fileExistsAtPath(path) {
      var error: NSError?
      if !fileManager.removeItemAtPath(path, error: &error) {
        println("Error removing file: \(error!)")
      }
    }
  }
  //#####################################################################
}
