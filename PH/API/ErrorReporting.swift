//
//  ErrorReporting.swift
//  PH
//
//  Created by Marco on 20/08/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import Foundation
import UIKit

//https://stackoverflow.com/a/40016326

class ErrorReporting {
    
    static func showMessage(title: String = "Error", msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
