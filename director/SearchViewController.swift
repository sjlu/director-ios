//
//  SearchViewController.swift
//  director
//
//  Created by Steven Lu on 1/4/15.
//  Copyright (c) 2015 Steven Lu. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    var data: NSMutableArray?
    //    var disableViewOverlay: UIView?
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var screenBounds = UIScreen.mainScreen().bounds;
        
        self.title = "Add Content"
        self.view.backgroundColor = UIColor.backgroundColor()
        
        self.data = NSMutableArray()
        
        //        self.disableViewOverlay = UIView(frame: CGRect(x: 0, y: 44, width: screenBounds.width, height: screenBounds.height))
        //        self.disableViewOverlay?.backgroundColor = UIColor.blackColor()
        //        self.disableViewOverlay?.alpha = 0
        
        self.searchBar = UISearchBar(frame: CGRect(x: -10, y: 0, width: screenBounds.width-90, height: 44))
        self.searchBar?.delegate = self
        self.searchBar?.searchBarStyle = UISearchBarStyle.Minimal
        self.searchBar?.placeholder = "Search for a movie"
        
        var searchBarView = UIView(frame: CGRect(x: -10, y: 0, width: screenBounds.width-90, height: 44))
        searchBarView.addSubview(searchBar!)
        self.navigationItem.titleView = searchBarView
        
        var closeViewButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "closeButtonPressed:")
        self.navigationItem.rightBarButtonItem = closeViewButton
        
        // table stuff
        //        self.tableView.registerClass(UITableViewCell.self as AnyClass, forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // search
    func doSearch(search:String) {
        Alamofire.request(
            Router.Search(search)
            ).responseJSON { (request, response, data, error) in
                self.data = data as? NSMutableArray
                self.tableView.reloadData()
        }
    }
    
    // view related
    override func viewWillAppear(animated: Bool) {
        self.searchBar?.becomeFirstResponder()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.searchBar?.resignFirstResponder()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar?.resignFirstResponder()
    }
    
    // close button related
    func closeButtonPressed(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // search bar related
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(false)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    // tableview realted
    override func viewDidLayoutSubviews() {
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data == nil {
            return 0
        } else {
            return self.data!.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        var cell:SearchTableViewCell? = tableView.dequeueReusableCellWithIdentifier("SearchTableViewCell", forIndexPath: indexPath) as? SearchTableViewCell
        var cell : SearchTableViewCell? = tableView.dequeueReusableCellWithIdentifier("SearchTableViewCell") as? SearchTableViewCell
        if cell == nil {
            cell = SearchTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "SearchTableViewCell")
            cell?.setUpCell()
        }
        
        var cellData:AnyObject? = self.data?.objectAtIndex(indexPath.row)
        cell?.configureWithMovie(cellData!)
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cellData:AnyObject? = self.data?.objectAtIndex(indexPath.row)
        Alamofire.request(
            Router.AddMovie(cellData!)
            ).responseJSON { (request, response, data, error) in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}