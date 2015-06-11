//
//  SearchTableViewCell.swift
//  director
//
//  Created by Steven Lu on 1/5/15.
//  Copyright (c) 2015 Steven Lu. All rights reserved.
//

import UIKit
import Haneke

class AppTableViewCell: UITableViewCell {
    
    var movieView: UIView?
    var posterImageView: UIImageView?
    var movieTitleLabel: UILabel?
    var statusLabel: UILabel?
    
    func setUpCell() {
        movieView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 75))
        posterImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 75))
        
        movieView?.addSubview(posterImageView!)
        self.contentView.addSubview(posterImageView!)
        
        movieTitleLabel = UILabel(frame: CGRect(x: 70, y: 30, width: 235, height: 20))
        movieTitleLabel?.font = UIFont.primaryFontWithSize(16)
        self.addSubview(movieTitleLabel!)
        
        statusLabel = UILabel(frame: CGRect(x: 70, y: 50, width: 235, height: 20))
        statusLabel?.font = UIFont.primaryFontLightWithSize(13)
        self.addSubview(statusLabel!)
    }
    
    func configureWithMovie(movie:Movie) {
        posterImageView?.image = nil

        var url = NSURL(string: movie.poster_url!)
        posterImageView?.hnk_setImageFromURL(url!)
        
        movieTitleLabel?.text = movie.title
        statusLabel?.text = movie.status
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}