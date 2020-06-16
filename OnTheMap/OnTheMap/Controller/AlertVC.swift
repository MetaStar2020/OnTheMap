//
//  AlertVC.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class AlertVC {
    
    static func showMessage(title: String, msg: String, `on` controller: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
}
