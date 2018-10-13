//
//  ViewController.swift
//  dbTest1
//
//  Created by Jonathan Nehring on 10/11/18.
//  Copyright © 2018 stonetip. All rights reserved.
//

import UIKit
import SQLite3
import GRDB

class ViewController: UIViewController {
    
    var dbQueue: DatabaseQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteDatabase();
        
        copyDatabaseIfNeeded()
        
        openDB()
        
        readValues()
    }
    
    
    func openDB(){
        
        do{
            let fileManager = FileManager.default
            
            let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask)
            
            guard documentsUrl.count != 0 else {
                return
            }
            
            let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("dbTest1.sqlite")
            
           dbQueue = try DatabaseQueue(path: finalDatabaseURL.path)
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
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
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    
    // Delete a database from documents (basically for testing/dev purposes
    func deleteDatabase(){
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("dbTest1.sqlite")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            return
        } else {
            print("DB file found at path: \(finalDatabaseURL.path)")
            
            do{
                try fileManager.removeItem(at: finalDatabaseURL)
                print("DB file was removed.")
            }
            catch let error as NSError{
                print("Could not remove DB: \(error.debugDescription)")
            }
        }
    }
    
    // Move prototype database file from bundle to documents folder
    func copyDatabaseIfNeeded() {

        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("dbTest1.sqlite")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("dbTest1.sqlite")
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
                print("DB copied over to documents folder")
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }
    
    
    
    
    func addLocation(db: OpaquePointer)
    {
        let cmdStr = "INSERT INTO locations VALUES (3, 46.123456, -112.654321, 1234.0, 5.0, 5.0, 1.0, 10.0, '2018-10-10 19:33:55');"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, cmdStr, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert : \(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            return
        }
    }
    
    func removeLocations(db: OpaquePointer)
    {
        let cmdStr = "DELETE FROM locations WHERE tid = 2;"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, cmdStr, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing deletion : \(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting: \(errmsg)")
            return
        }
    }
    
}

