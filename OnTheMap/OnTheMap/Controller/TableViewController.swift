//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit


class TableViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Class Properties: Variables and Constants
    
    let OTMCellID = "OTMTableCell"
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.reloadData()
    }
        
}

// MARK: - UITableViewDataSource Functions (required)

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.studentLocations.count
    }

    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: OTMCellID , for: indexPath)
        print(indexPath)
       
       // Configure the cell’s contents.
        cell.imageView!.image = UIImage(named: "icon_pin")
        cell.textLabel!.text = StudentLocationModel.studentLocations[indexPath.row].firstName + " " + StudentLocationModel.studentLocations[indexPath.row].lastName
        cell.detailTextLabel!.text = StudentLocationModel.studentLocations[indexPath.row].mediaURL
           
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = URL(string: StudentLocationModel.studentLocations[indexPath.row].mediaURL){
            
            if UIApplication.shared.canOpenURL(mediaURL) && mediaURL.absoluteString.contains("https") {
               UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
             } else { //mediaURL does not open
                AlertVC.showMessage(title: "Cannot Open Link", msg: "Media contains a wrong URL format", on: self)
            }
        } else {
            AlertVC.showMessage(title: "Incorrect URL Format", msg: "There is no URL specified", on: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
