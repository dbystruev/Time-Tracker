//
//  UIColor+constants.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 24/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Use https://color.adobe.com to create
extension UIColor {
    struct Header {
        struct Background {
            static var running: UIColor { return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) }
            static var stopped: UIColor { return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
        }
        struct Text {
            static var running: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
            static var stopped: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
        }
    }
    
    struct Cell {
        struct Background {
            static var running: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
            static var stopped: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
        }
        struct Text {
            static var running: UIColor { return #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1) }
            static var stopped: UIColor { return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) }
        }
    }
    
    var inverted: UIColor {
        let zero = CGFloat(0)
        var red = zero
        var green = zero
        var blue = zero
        var alpha = zero
        
        UIColor.red.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
}
