//
//  ImageSaver.swift
//  BeerTracker
//
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit

class ImageSaver {
  
  //#####################################################################
  // MARK: - Save Image
  
  class func saveImageToDisk(_ image: UIImage, andToBeer beer: AnyObject) -> Bool {
    
    let imgData = UIImageJPEGRepresentation(image, 0.5)
    let name = UUID().uuidString
    let fileName = "\(name).jpg"
    let nsString : NSString = applicationDocumentsDirectory as NSString
    let pathName = nsString.appendingPathComponent(fileName)
    
    //------------------------------------------
    guard let pathURL = URL(string:pathName) else {
        return false
    }
    do {
     try imgData?.write(to: pathURL)
    } catch {
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
                         preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alert.present(alert, animated: true, completion: nil)
    alert.addAction(okAction)
  }
  //#####################################################################
  // MARK: - Delete Image
  
  class func deleteImageAtPath(_ path: String) {
    
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: path) {
        do {
          try fileManager.removeItem(atPath: path)
        } catch let error as NSError {
            print("Error removing file: \(error)")
        }
    }
  }
  //#####################################################################
}
