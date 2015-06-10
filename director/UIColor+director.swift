//
//  UIColor+director.swift
//  bout
//
//  Created by Steven Lu on 10/2/14.
//  Copyright (c) 2014 Steven Lu. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    class func primaryColor() -> UIColor {
        return UIColor(rgb: 0x34495E)
    }
    
    class func backgroundColor() -> UIColor {
        return UIColor(rgb: 0xF5F5F5)
    }
    
}