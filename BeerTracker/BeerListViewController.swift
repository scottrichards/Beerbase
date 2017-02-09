//
//  ViewController.swift
//  BeerTracker
//
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import Foundation

class BeerListViewController: UITableViewController {

  @IBOutlet weak var sortByControl: UISegmentedControl!
  @IBOutlet weak var searchBar: UISearchBar!
  
  let sortKeyName   = "name"
  let sortKeyRating = "beerDetails.rating"
  let wbSortKey     = "wbSortKey"

  //------------------------------------------
  // Rating
  
  var amRatingCtl: AnyObject!
  
  let beerEmptyImage: UIImage = UIImage(named: "beermug-empty")!
  let beerFullImage:  UIImage = UIImage(named: "beermug-full")!
  
  //#####################################################################
  // MARK: - Initialization
  
  required init?(coder aDecoder: NSCoder) {
    // Automatically invoked by UIKit as it loads the view controller from the storyboard.
    
    amRatingCtl = AMRatingControl(location: CGPoint(x: 190, y: 10),
                                empty: beerEmptyImage,
                                solidImage: beerFullImage,
                              andMaxRating: 5)    
    
    // A call to super is required after all variables and constants have been assigned values but before anything else is done.
    super.init(coder: aDecoder)
  }
  //#####################################################################
  // MARK: - Segues
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Allows data to be passed to the new view controller before the new view is displayed.
    
    // "destinationViewController" must be cast from its generic type (AnyObject) to the specific type used in this app
    // (BeerDetailViewController) before any of its properties can be accessed.
    let controller = segue.destination as? BeerDetailViewController
    
    if segue.identifier == "editBeer" {

      controller!.navigationItem.rightBarButtonItems = []
      
    //------------------------------------------------------------------------------------
    } else if segue.identifier == "addBeer" {
      
      controller!.navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Cancel",
                                                                      style: UIBarButtonItemStyle.plain,
                                                                     target: controller,
                                                                     action: "cancelAdd")
      
      controller!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                      style: UIBarButtonItemStyle.done,
                                                                     target: controller,
                                                                     action: "addNewBeer")
    }
  }
  //#####################################################################
  // MARK: - UIViewController - Responding to View Events
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    //------------------------------------------
    // Sorting Key
    
    if !(UserDefaults.standard.object(forKey: wbSortKey) != nil) {
      // User's sort preference has not been saved.  Set default to sort by rating.
      UserDefaults.standard.set(sortKeyRating, forKey: wbSortKey)
    }
    
    // Keep the sort control in the UI in sync with the means by which the list is sorted.
    if UserDefaults.standard.object(forKey: wbSortKey) as! String == sortKeyName {
      sortByControl.selectedSegmentIndex = 1
    }
    //------------------------------------------
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
    
    tableView.contentOffset = CGPoint(x: 0, y: 44)
  }
  //#####################################################################
  // MARK: - Action Methods
  
  @IBAction func sortByControlChanged(_ sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
      
    case 0:
      UserDefaults.standard.set(sortKeyRating, forKey: wbSortKey)
      fetchAllBeers()
      tableView.reloadData()

    case 1:
      UserDefaults.standard.set(sortKeyName, forKey: wbSortKey)
      fetchAllBeers()
      tableView.reloadData()

    default:
      break
    }
  }
  //#####################################################################
  // MARK: - MagicalRecord Methods
  
  func fetchAllBeers() {
  }
  //#####################################################################
  
  func saveContext() {
  }
  //#####################################################################
}

//#####################################################################
// MARK: - Table View Data Source

extension BeerListViewController {
  
  //#####################################################################
  // MARK: Configuring a Table View
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  //#####################################################################

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  //#####################################################################

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
    var cell : UITableViewCell = UITableViewCell()
    if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    {
        configureCell(dequeueCell, atIndex: indexPath)
        cell = dequeueCell
    }
    return cell
  }
  //#####################################################################
  // MARK: Helper Methods
  
  func configureCell(_ cell: UITableViewCell, atIndex indexPath: IndexPath) {

    //------------------------------------------
    // Rating
    
    let ratingText = ""
    
    let myRect = CGRect(x:250, y:0, width:200, height:50)
    var ratingLabel = UILabel(frame: myRect)
    
    if !(cell.viewWithTag(20) != nil) {
      
      ratingLabel.tag = 20
      ratingLabel.text = ratingText
      cell.addSubview(ratingLabel)
      
    } else {
      ratingLabel = cell.viewWithTag(20) as! UILabel
    }
    //----------------------
    ratingLabel.text = ratingText
    
  }
  //#####################################################################
  // MARK: Inserting or Deleting Table Rows
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  //#####################################################################
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    // When the commitEditingStyle method is present in a view controller, the table view will automatically enable swipe-to-delete.
    
    if (editingStyle == .delete) {
      
    }
  }
  //#####################################################################
}
//#####################################################################
// MARK: - Search Bar Delegate

extension BeerListViewController: UISearchBarDelegate {
  
  // MARK: Editing Text
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchBar.text != "" {
      performSearch()
      
    } else {
      fetchAllBeers()
      tableView.reloadData()
    }
  }
  //#####################################################################
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  //#####################################################################
  // MARK: Clicking Buttons
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
    searchBar.resignFirstResponder()
    searchBar.text = ""
    searchBar.showsCancelButton = false
    fetchAllBeers()
    tableView.reloadData()
  }
  //#####################################################################

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // This method is invoked when the user taps the Search button on the keyboard.
    
    searchBar.resignFirstResponder()
    performSearch()
  }
  //#####################################################################
  // MARK: Helper Methods
  
  func performSearch() {
    tableView.reloadData()
  }
  //#####################################################################
  // MARK: - Bar Positioning Delegate
  //         UISearchBarDelegate Protocol extends UIBarPositioningDelegate protocol.
  //         Method positionForBar is part of the UIBarPositioningDelegate protocol.
  
  // This delegate method is required to prevent a gap between the top of the screen and the search bar.
  // That happens because, as of iOS 7, the status bar is no longer a separate area but is directly drawn on top of the view controller.
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    // Tell the search bar to extend under the status bar area.
    
    return .topAttached
  }
  //#####################################################################
}

