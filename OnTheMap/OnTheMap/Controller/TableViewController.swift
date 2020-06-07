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
    
    //MARK: - Properties: Variables and Constants
    
    let OTMCellID = "OTMTableCell"
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.reloadData()
    }
        
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Required functions for UITableViewDataSource
    
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
           
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = URL(string: StudentLocationModel.studentLocations[indexPath.row].mediaURL){
                UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
            } else {
            //showAlert(ofType: .incorrectURLFormat, message: "Media contains a wrong URL format")
        }
    }
}
