//
//  Router.swift
//  bout
//
//  Created by Steven Lu on 10/1/14.
//  Copyright (c) 2014 Steven Lu. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "https://thedirector.herokuapp.com"
    
    case Movies()
    case Search(String)
    case AddMovie(AnyObject)
    
    var method: Alamofire.Method {
        switch self {
        case .AddMovie: return .POST
        default: return .GET
        }
    }
    
    var path: String {
        switch self {
        case .Movies: return "/api/movies"
        case .Search(let term): var t = term.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding); return "/api/movies/search?q=\(t!)"
        case .AddMovie(let movie): return "/api/movies"
        default: return ""
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let urlString = Router.baseURLString + self.path;
        let URL = NSURL(string: urlString)
        let mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .AddMovie(let movie):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["movie": movie]).0
        default:
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: nil).0
        }
    }
}