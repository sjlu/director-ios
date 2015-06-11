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

    // Status -> Movies
    var data: [String:[Movie]!] = [:]
    var screenBounds: CGRect!
    
    func getMovies() {
        var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        Alamofire.request(
            Router.Movies()
            ).responseJSON { (request, response, data, error) in
                // map dictionaries to Movie struct
                let movies = data!.allObjects.map {
                    (var object) -> Movie in
                    var dict = object as! [String:AnyObject]
                    var movie = Movie(title: dict["title"] as! String, tmdb_id: dict["tmdb_id"] as! NSNumber)
                    movie.poster_url = dict["poster_url"] as? String
                    movie.status = dict["status"] as! String
                    return movie
                }

                for movie in movies {
                    if (self.data[movie.status] != nil) {
                        self.data[movie.status]?.append(movie)
                    }
                    else {
                        self.data[movie.status] = [movie]
                    }
                }

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

    // tableview realted
    override func viewDidLayoutSubviews() {
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.data.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return self.data.keys.array[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.data.keys.array[section]
        return self.data[key]!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95
    }

    func movieForIndexPath(indexPath: NSIndexPath) -> Movie {
        return self.data[self.data.keys.array[indexPath.section]]![indexPath.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : AppTableViewCell? = tableView.dequeueReusableCellWithIdentifier("AppTableViewCell") as? AppTableViewCell
        if cell == nil {
            cell = AppTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AppTableViewCell")
            cell?.setUpCell()
        }
        cell?.configureWithMovie(movieForIndexPath(indexPath))
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // [???]: Why can you add from the movies that have already been downloaded added?
        Alamofire.request(
            Router.AddMovie(movieForIndexPath(indexPath))
            ).responseJSON { (request, response, data, error) in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}