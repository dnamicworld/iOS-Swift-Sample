//
//  CustomSearchController.swift
//  honeygrow
//
//  Created by Jorge Paiz on 1/27/16.
//  Copyright © 2016 Andres Garcia Figueroa. All rights reserved.
//



import UIKit



protocol CustomSearchControllerDelegate {
  
  func didStartSearching()
  func didEndSearching()
  func didTapOnSearchButton()
  func didTapOnCancelButton()
  func didChangeSearchText(searchText: String)
  
}



class CustomSearchController: UISearchController {
  
  
  
  // MARK: - Public Properties
  var customSearchBar: CustomSearchBar!
  var customDelegate:  CustomSearchControllerDelegate!
  
  
  
  // MARK: - Private Properties
  
  
  
  //  MARK: - Lifecycle of component
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  
  // MARK: Initialization
  init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
    super.init(searchResultsController: searchResultsController)
    
    configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  
  // MARK: - Private Methods
  private func configureSearchBar(frame frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
    customSearchBar = CustomSearchBar(frame: frame, font: font, textColor: textColor)
    customSearchBar.barTintColor        = bgColor
    customSearchBar.tintColor           = bgColor
    customSearchBar.delegate            = self
  }
  
  
  
  // MARK: - Public Mehtods
  
  
  
}



// MAKR: - Extension of UISearchControlerDelegate
extension CustomSearchController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    customDelegate.didStartSearching()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    customSearchBar.resignFirstResponder()
    customDelegate.didTapOnSearchButton()
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    customSearchBar.resignFirstResponder()
    customDelegate.didTapOnCancelButton()
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    customDelegate.didChangeSearchText(searchText)
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    customDelegate.didEndSearching()
  }
  
}


