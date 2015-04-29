//
//  PhotoViewController.swift
//  BeerTracker
//
//  Created by Ed on 4/27/15.
//  Copyright (c) 2015 Anros Applications, LLC. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  //------------------------------------------
  // If no photo is picked yet, image is nil, so this must be an optional.
  var image: UIImage?

  //#####################################################################
  // MARK: - UIViewController - Managing the View
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //------------------------------------------
    
    imageView.image = image
  }
  //#####################################################################
}
