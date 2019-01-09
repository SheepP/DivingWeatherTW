//
//  UIView+O2CornerRadius.swift
//  TheWeather2
//
//  Created by 鄭羽辰 on 2018/12/5.
//  Copyright © 2018 鄭羽辰. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    @IBInspectable var cornerRadius:CGFloat{
        get{
            return layer.cornerRadius
        }
        // also set(newValue)
    set{
    layer.cornerRadius = newValue
        }
    }
}
