//
//  CustomViews.swift
//  banquemisr.challenge05.*
//
//  Created by Marco on 2024-09-27.
//

import Foundation
import UIKit

//@IBDesignable
class CustomImageView: UIImageView {
    @IBInspectable var Rounded: Bool = false {
        didSet {
            layer.cornerRadius = Rounded ? 10 : 0
            //layer.masksToBounds = Rounded ? true : false
        }
    }
    
    @IBInspectable var Shadowed: Bool = false {
        didSet {
            layer.shadowRadius = 12
            layer.shadowOpacity = 0.28
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowColor = UIColor.gray.cgColor
            //clipsToBounds = false
        }
    }
    
    @IBInspectable var bordered: Bool = false {
        didSet {
            layer.borderWidth = bordered ? 2.0 : 0
            layer.borderColor = UIColor.lightGray.cgColor
            layer.cornerRadius = 10.0
            //layer.masksToBounds = true // Clip to bounds
        }
    }
}


//@IBDesignable
class CustomView: UIView {
    @IBInspectable var Rounded: Bool = false {
        didSet {
            layer.cornerRadius = Rounded ? 10 : 0
            //layer.masksToBounds = Rounded ? true : false
        }
    }
    
    @IBInspectable var Shadowed: Bool = false {
        didSet {
            layer.shadowRadius = 12
            layer.shadowOpacity = Shadowed ? 0.28 : 0
            layer.shadowOffset = CGSize(width: 0, height: 20)
            layer.shadowColor = UIColor.gray.cgColor
            //clipsToBounds = false
        }
    }
    
    @IBInspectable var bordered: Bool = false {
        didSet {
            layer.borderWidth = bordered ? 2.0 : 0
            layer.borderColor = UIColor.lightGray.cgColor
            layer.cornerRadius = 10.0
            //layer.masksToBounds = true // Clip to bounds
        }
    }
}
