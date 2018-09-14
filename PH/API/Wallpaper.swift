//
//  Wallpaper.swift
//  PH
//
//  Created by Marco on 14/09/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import Foundation

class Wallpaper {
    var low_res_link : String
    var detail_link: String
    
    init(low_res_link : String, detail_link: String) {
        self.low_res_link  = low_res_link
        self.detail_link = detail_link
    }
}
