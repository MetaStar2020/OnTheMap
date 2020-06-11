//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-06-09.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        StudentLocation.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
