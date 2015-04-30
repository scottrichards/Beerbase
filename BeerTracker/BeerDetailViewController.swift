//
//  BeerDetailViewController.swift
//  BeerTracker
//
//  Created by Ed on 4/27/15.
//  Copyright (c) 2015 Anros Applications, LLC. All rights reserved.
//

import UIKit

class BeerDetailViewController: UITableViewController {
  
  @IBOutlet weak var beerNameTextField: UITextField!
  @IBOutlet weak var beerNotesView: UITextView!
  @IBOutlet weak var cellOne: UITableViewCell!
  
  //------------------------------------------
  // Showing the image
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var addPhotoLabel: UILabel!
  
  //var image: UIImage?   // If no photo has been picked yet, image is nil, so the variable must be an optional.
  
  // Set up a "Property Observer" using a "didSet block" instead of just declaring the variable as above.
  // The code in the didSet block is performed whenever the variable is assigned a new value.
  
  var image: UIImage? {
    didSet {
      
      // Store the photo in the image instace variable for later use.
      if let image = image {
        showImage(image)
      }
    }
  }
  //------------------------------------------
  var currentBeer: Beer!
  //var currentBeerDetails: BeerDetails!
  
  //#####################################################################
  // MARK: - Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    // The segue’s destinationViewController is the PhotoViewController, not a UINavigationController.
    
    // "destinationViewController" must be cast from its generic type (AnyObject) to the specific type used in this app
    // (PhotoViewController) before any of its properties can be accessed.
    let controller = segue.destinationViewController as! PhotoViewController
    
    controller.image = imageView.image
  }
  /*
  //#####################################################################
  // MARK: - Unwind Segues
  
  // An unwind segue is an action method that takes a UIStoryboardSegue parameter.
  
  @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue) {
    // A storyboard connection was made from the prototype cell in the CategoryPickerViewController to that view controller's Exit button
    // to engage this unwind segue.
    
    // Get the selected Category from the view controller that sent the segue - CategoryPickerViewController.
    let controller = segue.sourceViewController as CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
  }
*/
  //#####################################################################
  // MARK: - UIViewController
  
  // MARK: Managing the View
  
  // viewDidLoad() is called after prepareForSegue().

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //------------------------------------------
    beerNotesView.layer.borderColor = UIColor(white: 0.667, alpha: 0.500).CGColor
    beerNotesView.layer.borderWidth = 1.0
    
    //------------------------------------------
    if let beer = currentBeer {
      // A beer exists.  EDIT Mode.
      
    } else {
      // A beer does NOT exist.  ADD Mode.
      
      currentBeer = Beer.createEntity() as! Beer
      currentBeer.name = ""
    }
    //------------------------------------------
    let details: BeerDetails? = currentBeer.beerDetails
    
    if let bDetails = details {
      // Beer Details exist.  EDIT Mode.
      
    } else {
      // Beer Details do NOT exist.  Either ADD Mode or EDIT Mode with a beer that has no details.
      
      currentBeer.beerDetails = BeerDetails.createEntity() as! BeerDetails
    }
    //------------------------------------------
    // Update user interface with attribute values.
    
    //--------------------
    // BEER NAME
    
    let cbName: String? = currentBeer.name
    
    if let bName = cbName {
      beerNameTextField.text = bName
    }
    //--------------------
    // BEER NOTE
    
    if let bdNote = details?.note {
      beerNotesView.text = bdNote
    }
    //--------------------
    // BEER IMAGE
    
    if let beerImagePath = details?.image {
      
      let beerImage = UIImage(contentsOfFile: beerImagePath)
      
      if let bImage = beerImage {
        showImage(bImage)
      }
      
      //let fileMgr = NSFileManager.defaultManager()
      /*
      if fileMgr.fileExistsAtPath(beerImagePath) {
        let image: UIImage? = UIImage(contentsOfFile: beerImagePath)
        if let beerImage = image {
          // An image exists.
          showImage(beerImage)
        }
      }
      */
      /*
      let image: UIImage? = UIImage(contentsOfFile: beerImagePath)
      if let beerImage = image {
        // An image exists.
        showImage(beerImage)
      }
      */
      /*
      let image: UIImage? = UIImage(named: beerImagePath)
      if let beerImage = image {
        // An image exists.
        showImage(beerImage)
      }
      */
      /*
      var image: UIImage? = UIImage(named: beerImagePath)
      if let beerImage = image {
        // An image exists.
        showImage(beerImage)
      }
      */
      /*
      var image: UIImage = UIImage(named: "/Users/Ed/Library/Developer/CoreSimulator/Devices/31B79762-F078-456B-8B4C-34BF25E7BD61/data/Containers/Data/Application/60195229-75F3-44EE-B264-850DA6214D32/Documents/68F282D8-3473-4335-A878-121B952C1172.jpg")!

      if let beerImage = image {
        // An image exists.
        showImage(beerImage)
      }
      */
    }
    //------------------------------------------
    // Set scene title.
    
    if currentBeer.name == "" {
      title = "New Beer"
    } else {
      title = currentBeer.name
    }
  }
  //#####################################################################
  // MARK: Responding to View Events
  
  override func viewWillDisappear(animated: Bool) {
    
    super.viewWillDisappear(true)
    
    //------------------------------------------
    
    beerNameTextField.resignFirstResponder()
    beerNotesView.resignFirstResponder()
    
    saveContext()
  }
  //#####################################################################
  // MARK: - Action Methods
  
  @IBAction func didFinishEditingBeer(sender: UITextField) {
    
    beerNameTextField.resignFirstResponder()
  }
  //#####################################################################
  
  @IBAction func takePicture(sender: UITapGestureRecognizer) {
    pickPhoto()
  }
  //#####################################################################
  // MARK: - Helper Methods
  
  func cancelAdd() {
    currentBeer.deleteEntity()
    navigationController?.popViewControllerAnimated(true)
  }
  //#####################################################################
  
  func addNewBeer() {
    navigationController?.popViewControllerAnimated(true)
  }
  //#####################################################################
  // MARK: - MagicalRecord Methods
  
  func saveContext() {
    NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
  }
  //#####################################################################
}
//#####################################################################
// MARK: - Text Field Delegate

extension BeerDetailViewController: UITextFieldDelegate {
  
  // MARK: Managing Editing
  
  func textFieldDidEndEditing(textField: UITextField) {
    
    if textField.text != "" {
      self.title       = textField.text
      currentBeer.name = textField.text
    }
  }
  //#####################################################################
}
//#####################################################################
// MARK: - Text View Delegate

extension BeerDetailViewController: UITextViewDelegate {
  
  // MARK: Responding to Editing Notifications
  
  func textViewDidEndEditing(textView: UITextView) {
    
    textView.resignFirstResponder()
    
    if textView.text != "" {
      currentBeer.beerDetails.note = textView.text
    }
  }
  //#####################################################################
}
//#####################################################################
// MARK: - Table View Delegate

extension BeerDetailViewController: UITableViewDelegate {
}

//#####################################################################
// MARK: - Gesture Recognizer Delegate

extension BeerDetailViewController: UIGestureRecognizerDelegate {
  
}
//#####################################################################
// MARK: - Image Picker Controller Delegate

// The view controller must conform to both UIImagePickerControllerDelegate and UINavigationControllerDelegate for image picking to work,
// but none of the UINavigationControllerDelegate methods have to be implemented.

extension BeerDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    // Called when the user has selected a photo in the image picker.
    
    // "[NSObject : AnyObject]" indicates that input parameter, info, is a dictionary with keys of type NSObject and values of type AnyObject.
    
    // Dictionaries always return optionals, because there is a theoretical possibility that the key for which data is being requested –
    // UIImagePickerControllerEditedImage in this case – doesn’t actually exist in the dictionary.
    // Under normal circumstances this optional, info[UIImagePickerControllerEditedImage], would be unwrapped,
    // but here the image instance variable is an optional itself so no unwrapping is necessary.
    
    // Use the UIImagePickerControllerEditedImage key to retrieve a UIImage object that contains the image after the Move and Scale operations on the original image.
    //image = info[UIImagePickerControllerEditedImage] as UIImage?
    image = info[UIImagePickerControllerEditedImage] as! UIImage?
    
    // THIS CODE WAS REPLACED WITH A didSet BLOCK FOR VARIABLE, image.
    // Store the photo in the image instace variable for later use.
    /*
    if let image = image {
    // Put the image in the Add Photo table view cell.
    showImage(image)
    }
    */

    //------------------------------------------
    if let imageToDelete = currentBeer.beerDetails.image {
      ImageSaver.deleteImageAtPath(imageToDelete)
    }
    
    //------------------------------------------
    // TODO: Is forced unwrapping safe to use here?
    if ImageSaver.saveImageToDisk(image!, andToBeer: currentBeer) {
      showImage(image!)
    }
    
    //------------------------------------------
    // Refresh the table view to set the photo row to the proper height to accommodate a photo (or not).
    tableView.reloadData()
    
    dismissViewControllerAnimated(true, completion: nil)
    //navigationController?.popViewControllerAnimated(true)
  }
  //#####################################################################
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    
    dismissViewControllerAnimated(true, completion: nil)
    //navigationController?.popViewControllerAnimated(true)
  }
  //#####################################################################
  
  func pickPhoto() {
    
    // Adding "true ||" introduces into the iOS Simulator fake availability of the camera.
    if true || UIImagePickerController.isSourceTypeAvailable(.Camera) {
      //if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      // The user's device has a camera.
      showPhotoMenu()
      
    } else {
      // The user's device does not have a camera.
      choosePhotoFromLibrary()
    }
  }
  //#####################################################################
  
  func showPhotoMenu() {
    // Show an alert controller with an action sheet that slides in from the bottom of the screen.
    
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    // handler: is given a Closure that calls the appropriate method.
    // The "_" wildcard is being used to ignore the parameter that is passed to this closure (which is a reference to the UIAlertAction itself).
    
    let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: { _ in self.takePhotoWithCamera() })
    alertController.addAction(takePhotoAction)
    
    let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .Default, handler: { _ in self.choosePhotoFromLibrary() })
    alertController.addAction(chooseFromLibraryAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  //#####################################################################
  
  func takePhotoWithCamera() {
    
    let imagePicker = UIImagePickerController()
    //let imagePicker = MyImagePickerController()
    
    imagePicker.sourceType = .Camera
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    
    //------------------------------------------
    // Make the photo picker's tint color (background color) the same as the view's.
    // This avoids having standard blue text on a dark gray navigation bar (assuming the view's tint color is set appropriately in the storyboard).
    imagePicker.view.tintColor = view.tintColor
    
    //------------------------------------------
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  //#####################################################################
  
  func choosePhotoFromLibrary() {
    
    let imagePicker = UIImagePickerController()
    //let imagePicker = MyImagePickerController()
    
    imagePicker.sourceType = .PhotoLibrary
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    
    //------------------------------------------
    // Make the photo picker's tint color (background color) the same as the view's.
    // This avoids having standard blue text on a dark gray navigation bar (assuming the view's tint color is set appropriately in the storyboard).
    imagePicker.view.tintColor = view.tintColor
    
    //------------------------------------------
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  //#####################################################################
  
  func showImage(image: UIImage) {
    
    // Put the image into the image view.
    imageView.image = image
    
    // Make the image view visible.
    imageView.hidden = false
    
    //--------------------
    // IMAGE FRAME SIZE
    
    // By default, an image view will stretch the image to fit the entire content area.
    // To keep the image's aspect ratio intact as it is resized, in the storyboard set the Image View's MODE to Aspect Fit.
    // Properly size the image view within the Beer Name table view cell.
    //imageView.frame = CGRect(x: 16, y: 18, width: 65, height: 65)
    
    let imageAspectRatio = image.size.width / image.size.height
    let imageViewFrameHeight = 65 / imageAspectRatio
    
    imageView.frame = CGRect(x: 16, y:18, width: 65, height: imageViewFrameHeight)
    
    //--------------------
    // Hide the label that prompts the user to add a photo.
    addPhotoLabel.hidden = true
  }
  //#####################################################################
}
