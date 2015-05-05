//
//  ViewController.swift
//  BeerTracker
//
//  Created by Ed on 4/24/15.
//  Copyright (c) 2015 Anros Applications, LLC. All rights reserved.
//

import UIKit
import Foundation

class BeerListViewController: UITableViewController {

  @IBOutlet weak var sortByControl: UISegmentedControl!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var beers: [Beer]!
  
  let SORT_KEY_NAME   = "name"
  let SORT_KEY_RATING = "beerDetails.rating"
  let WB_SORT_KEY     = "WB_SORT_KEY"

  //------------------------------------------
  // Rating
  
  var amRatingCtl: AnyObject!
  
  let beerEmptyImage: UIImage = UIImage(named: "beermug-empty")!
  let beerFullImage:  UIImage = UIImage(named: "beermug-full")!
  
  //#####################################################################
  // MARK: - Initialization
  
  required init(coder aDecoder: NSCoder) {
    // Automatically invoked by UIKit as it loads the view controller from the storyboard.
    
    amRatingCtl = AMRatingControl(location: CGPointMake(190, 10),
                                emptyImage: beerEmptyImage,
                                solidImage: beerFullImage,
                              andMaxRating: 5)
    
    // A call to super is required after all variables and constants have been assigned values but before anything else is done.
    super.init(coder: aDecoder)
  }
  //#####################################################################
  // MARK: - Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Allows data to be passed to the new view controller before the new view is displayed.
    
    // "destinationViewController" must be cast from its generic type (AnyObject) to the specific type used in this app
    // (BeerDetailViewController) before any of its properties can be accessed.
    let controller = segue.destinationViewController as? BeerDetailViewController
    
    if segue.identifier == "editBeer" {
      
      let indexPath = tableView.indexPathForSelectedRow()
      
      let beerSelected = beers[indexPath!.row]
      controller!.currentBeer = beerSelected
      controller!.currentBeer.beerDetails = beerSelected.beerDetails
      
      controller!.navigationItem.rightBarButtonItems = []
      
    //------------------------------------------------------------------------------------
    } else if segue.identifier == "addBeer" {
      
      controller!.navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Cancel",
                                                                      style: UIBarButtonItemStyle.Plain,
                                                                     target: controller,
                                                                     action: "cancelAdd")
      
      controller!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                      style: UIBarButtonItemStyle.Done,
                                                                     target: controller,
                                                                     action: "addNewBeer")
    }
  }
  //#####################################################################
  // MARK: - UIViewController - Responding to View Events
  
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    
    fetchAllBeers()
    
    // Cause tableView(cellForRowAtIndexPath) to be called again for every visible row in order to update the table.
    tableView.reloadData()
  }
  //#####################################################################
  // MARK: - UIViewController - Managing the View
  
  // viewDidLoad() is called after prepareForSegue().
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //------------------------------------------
    
    tableView.contentOffset = CGPointMake(0, 44)
  }
  //#####################################################################
  // MARK: - Action Methods
  
  @IBAction func sortByControlChanged(sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
      
    case 0:
      NSUserDefaults.standardUserDefaults().setObject(SORT_KEY_RATING, forKey: WB_SORT_KEY)
      fetchAllBeers()
      tableView.reloadData()

    case 1:
      NSUserDefaults.standardUserDefaults().setObject(SORT_KEY_NAME, forKey: WB_SORT_KEY)
      fetchAllBeers()
      tableView.reloadData()

    default:
      break
    }
  }
  //#####################################################################
  // MARK: - MagicalRecord Methods
  
  func fetchAllBeers() {
    
    let sortKey = NSUserDefaults.standardUserDefaults().objectForKey(WB_SORT_KEY) as? String
    let ascending = (sortKey == SORT_KEY_RATING) ? false : true
    
    // Fetch records from Entity Beer using a MagicalRecord method.
    beers = Beer.findAllSortedBy(sortKey, ascending: ascending) as! [Beer]
  }
  //#####################################################################
  
  func saveContext() {
    NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
  }
  //#####################################################################
}

//#####################################################################
// MARK: - Table View Data Source

extension BeerListViewController: UITableViewDataSource {
  
  //#####################################################################
  // MARK: Configuring a Table View
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  //#####################################################################

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beers.count
  }
  //#####################################################################

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
      
    //------------------------------------------
    // Use prototype cells designed in Interface Builder instead of creating the table view cell in code.
    
    // Get a copy of the prototype cell – either a new one or a recycled one.
    // Type Cast Note:
    //   dequeueReusableCellWithIdentifier() can return nil if there is no cell object to reuse.
    //   When using prototpye cells, however, dequeueReusableCellWithIdentifier() will never return nil,
    //   so a non-optional constant can be type cast using "as UITableViewCell" (as opposed to "as? UITableViewCell" for an optional).
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell
    
    //------------------------------------------
    configureCell(cell, atIndex: indexPath)
    
    //------------------------------------------
    return cell
  }
  //#####################################################################
  // MARK: Helper Methods
  
  func configureCell(cell: UITableViewCell, atIndex indexPath: NSIndexPath) {
    
    let currentBeer = beers[indexPath.row]
    cell.textLabel?.text = currentBeer.name
    
    //------------------------------------------
    // Rating Control
    
    if let amrc = amRatingCtl as? AMRatingControl {
      
      if !(cell.viewWithTag(20) != nil) {
        
        amrc.tag = 20
        amrc.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        amrc.userInteractionEnabled = false
        
        // TODO: This gets executed but no images show up in the cell.
        cell.addSubview(amrc)
        
        /*
        if let bdRating = details?.rating {
          let theRatingControl = ratingControl()
          theRatingControl.rating = Int(bdRating)
          cellNameRatingImage.addSubview(theRatingControl)
        }
        */

      } else {
        amRatingCtl = cell.viewWithTag(20)
      }
      //----------------------
      amrc.rating = Int(currentBeer.beerDetails.rating!)
    }
  }
  //#####################################################################
  // MARK: Inserting or Deleting Table Rows
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  //#####################################################################
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    // When the commitEditingStyle method is present in a view controller, the table view will automatically enable swipe-to-delete.
    
    if (editingStyle == .Delete) {
      
      beers.removeAtIndex(indexPath.row).deleteEntity()
      saveContext()
      
      // Prepare to delete the corresponding row from the table view.
      // Make a temporary array with only one index-path object.
      let indexPaths = [indexPath]
      
      // Tell the table view to remove the row(s) in the temporary array with an animation.
      tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
      
      // Reloaded the table view to reflect the deletion.
      tableView.reloadData()
    }
  }
  //#####################################################################
}
//#####################################################################
// MARK: - Search Bar Delegate

extension BeerListViewController: UISearchBarDelegate {
  
  // MARK: Editing Text
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchBar.text != "" {
      performSearch()
      
    } else {
      fetchAllBeers()
      tableView.reloadData()
    }
  }
  //#####################################################################
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  //#####################################################################
  // MARK: Clicking Buttons
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    
    searchBar.resignFirstResponder()
    searchBar.text = ""
    searchBar.showsCancelButton = false
    fetchAllBeers()
    tableView.reloadData()
  }
  //#####################################################################

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    // This method is invoked when the user taps the Search button on the keyboard.
    
    searchBar.resignFirstResponder()
    performSearch()
  }
  //#####################################################################
  // MARK: Helper Methods
  
  func performSearch() {
    
    let searchText = searchBar.text
    let filterCriteria = NSPredicate(format: "name contains[c] %@", searchText)
    
    beers = Beer.findAllSortedBy(SORT_KEY_NAME, ascending: true,
                                            withPredicate: filterCriteria,
                                                inContext: NSManagedObjectContext.defaultContext()) as? [Beer]
    tableView.reloadData()
  }
  //#####################################################################
  // MARK: - Bar Positioning Delegate
  //         UISearchBarDelegate Protocol extends UIBarPositioningDelegate protocol.
  //         Method positionForBar is part of the UIBarPositioningDelegate protocol.
  
  // This delegate method is required to prevent a gap between the top of the screen and the search bar.
  // That happens because, as of iOS 7, the status bar is no longer a separate area but is directly drawn on top of the view controller.
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    // Tell the search bar to extend under the status bar area.
    
    return .TopAttached
  }
  //#####################################################################
}

