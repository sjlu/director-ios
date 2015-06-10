//
//  AppViewController.swift
//  director
//
//  Created by Steven Lu on 1/3/15.
//  Copyright (c) 2015 Steven Lu. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class AppViewController: UITableViewController {
    
    var data: NSMutableArray!
    var screenBounds: CGRect!
    
    func getMovies() {
        var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        Alamofire.request(
            Router.Movies()
            ).responseJSON { (request, response, data, error) in
                self.data = data as? NSMutableArray
                self.tableView.reloadData()
                activityIndicator.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchButtonPressed:")
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    override func viewWillAppear(animated: Bool) {
        getMovies()
    }
    
    func searchButtonPressed(sender:AnyObject) {
        
        var searchView = SearchViewController()
        var searchNavView = UINavigationController(rootViewController: searchView)
        presentViewController(searchNavView, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        var cell : AppTableViewCell? = tableView.dequeueReusableCellWithIdentifier("AppTableViewCell") as? AppTableViewCell
        if cell == nil {
            cell = AppTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AppTableViewCell")
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