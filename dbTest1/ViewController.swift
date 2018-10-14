//
//  ViewController.swift
//  dbTest1
//
//  Created by Jonathan Nehring on 10/11/18.
//  Copyright © 2018 stonetip. All rights reserved.
//

import UIKit
import GRDB

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readValues()
        
        addLoc(for: 3)
        
        removeLocs(for: 2)
        
        readValues()
    }
    
    
    func readValues(){
        
        // Read values:
        do{
            try dbQueue?.read { db in
                let locations =  try Row.fetchAll(db, "SELECT * FROM locations")
                for row in locations{
                    //                    let lat  = row["lat"] ?? 0.0
                    //                    print(lat)
                    print(row)
                }
                
                print("----------------------------")
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    
    func addLoc(for tid: Int)
    {
        do{
            try dbQueue?.write{db in
                try db.execute("INSERT INTO locations VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", arguments: [tid, 46.123456, -112.654321, 1234.0, 5.0, 5.0, 1.0, 10.0, Date()])
            }
        }catch let error as NSError {
            print("Couldn't insert record! Error:\(error.description)")
        }
    }
    
    
    func removeLocs(for tid: Int)
    {
        do{
            try dbQueue?.write{db in
                try db.execute("DELETE FROM locations WHERE tid = ?", arguments: [tid])
            }
        }catch let error as NSError {
            print("Couldn't delete record(s)! Error:\(error.description)")
        }
    }
}

