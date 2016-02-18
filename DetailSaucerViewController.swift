//
//  DetailSaucerViewController.swift
//  honeygrow
//
//  Created by Jorge Paiz on 2/15/16.
//  Copyright © 2016 Andres Garcia Figueroa. All rights reserved.
//



import UIKit



class DetailSaucerViewController: UIViewController {
  
  
  
  // MARK: - Public Properties
  var itemVO: MenuItemVO?
  
  
  
  // MARK: - Private Properties
  private var dataSource = [AdditionalVO]() {
    didSet {
      accompanimentsTableView.reloadData()
    }
  }
  private let visiblePositionOfIngredientView:CGFloat = 4.0
  private let hiddenPositionOfIngredientView:CGFloat  = 1000.0
  private var isShowingIngredients                    = false
  
  
  
  // MARK: - Outlets
  @IBOutlet weak var currencyLabel: HGLabel!
  @IBOutlet weak var saucerLabel: HGLabel!
  @IBOutlet weak var saucerUnderlineWithConstraint: NSLayoutConstraint!
  @IBOutlet weak var lookGoodButton: HGButton!
  @IBOutlet weak var accompanimentsTableView: UITableView!
  @IBOutlet weak var ingredientsCollectionView: UICollectionView!
  @IBOutlet weak var ingredientsView: UIView!
  @IBOutlet weak var ingredientViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var ingredientViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var collectionTitleLabel: HGLabel!
  @IBOutlet weak var collectionDescriptionLabel: HGLabel!
  
  
  
  // MAKR: - Actions
  @IBAction func cancelIngredients(sender: AnyObject) {
  }
  
  @IBAction func looksGood(sender: AnyObject) {
    
    if isShowingIngredients {
      isShowingIngredients = false
      
      // animation back
      UIView.animateWithDuration(0.5) { () -> Void in
        self.accompanimentsTableView.alpha = 1.0
      }
      ingredientViewTopConstraint.constant = hiddenPositionOfIngredientView
      UIView.animateWithDuration(0.6) { () -> Void in
        self.view.layoutIfNeeded()
      }
      
    }
    
  }
  
  
  
  // MARK: - Lifecycle of View
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initialValues()
    styleElements()
    
    dataSource = dummyData()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    ingredientViewTopConstraint.constant = hiddenPositionOfIngredientView
    lookGoodButton.titleLabel?.text = NSLocalizedString("accompaniments_button_text", comment: "")
    lookGoodButton.titleForState(UIControlState.Normal)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  
  // MARK: - Public Methods
  
  
  
  // MARK: - Private Methods
  private func styleElements() {
    Utils.softShadowToLayer(currencyLabel.layer)
    
    Utils.softShadowToLayer(saucerLabel.layer)
    
    saucerUnderlineWithConstraint.constant = Utils.widthOfTextInLabel(saucerLabel)
    
    lookGoodButton.greenFilledButtonStyle()
  }
  
  private func initialValues() {
    currencyLabel.text  = String(format: "$ %.2f", (itemVO?.price)!)
    saucerLabel.text    = itemVO?.productDescription?.uppercaseString
  }
  
  private func dummyData() ->[AdditionalVO] {
    var results = [AdditionalVO]()
    
    if let plist = NSBundle.mainBundle().pathForResource("SaucerDetail", ofType: "plist") {
      if let items = NSArray(contentsOfFile: plist) {
        for item in items {
          if let dictionary = item as? Dictionary<String, AnyObject> {
            var additional         = AdditionalVO()
            additional.id          = String(dictionary["id"]!)
            additional.title       = String(dictionary["title"]!)
            additional.description = String(dictionary["description"]!)
            results.append(additional)
          }
        }
      }
    }
    
    return results
  }
  
  
  
}



// MARK: - Extension UITableViewDataSource
extension DetailSaucerViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.accompanimentsTableView.dequeueReusableCellWithIdentifier("cellAccompaniment") as! DetailSaucerTableViewCell
    
    let additional = dataSource[indexPath.row]
    cell.showData(additional)
    
    return cell
  }
  
}



// MARK: - Extension UITableViewDelegate
extension DetailSaucerViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    accompanimentsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    accompanimentsTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    ingredientViewHeightConstraint.constant = CGRectGetHeight(accompanimentsTableView.frame)
    isShowingIngredients = true
    
    let item                  = dataSource[indexPath.row]
    collectionTitleLabel.text = item.title?.uppercaseString
    lookGoodButton.titleLabel?.text = NSLocalizedString("ingredients_button_text", comment: "") + collectionTitleLabel.text!.uppercaseString
    
    // animation 01
    UIView.animateWithDuration(0.5) { () -> Void in
      self.accompanimentsTableView.alpha = 0.0
    }
    ingredientViewTopConstraint.constant = visiblePositionOfIngredientView
    UIView.animateWithDuration(0.6) { () -> Void in
      self.view.layoutIfNeeded()
    }
  }
}



// MARK: - Extension UICollectionViewDataSource
extension DetailSaucerViewController: UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count * 2
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = self.ingredientsCollectionView.dequeueReusableCellWithReuseIdentifier("cellIngredient", forIndexPath: indexPath)
    
    
    return cell
  }
  
}



// MARK: - Extension UICollectionViewDataSource
extension DetailSaucerViewController: UICollectionViewDelegate {
  
}


