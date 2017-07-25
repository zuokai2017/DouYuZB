//
//  UIColor+Extension.swift
//  DouYuZB
//
//  Created by zuokai on 2017/6/2.
//  Copyright © 2017年 zuokai. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(r: CGFloat ,g : CGFloat , b : CGFloat) {
        
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
        
    }
}
