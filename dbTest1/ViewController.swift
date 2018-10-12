//
//  ViewController.swift
//  dbTest1
//
//  Created by Jonathan Nehring on 10/11/18.
//  Copyright © 2018 stonetip. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteDatabase();
        
        copyDatabaseIfNeeded()
        
        openDatabase()
    }
    
    func deleteDatabase(){
        // Move database file from bundle to documents folder
        
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
            print("Database file found at path: \(finalDatabaseURL.path)")
            
            do{
                 try fileManager.removeItem(at: finalDatabaseURL)
            }
            catch let error as NSError{
                print("Could not remove database: \(error.debugDescription)")
            }
        }
    }
    
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
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
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }
    
    func openDatabase() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("dbTest1.sqlite")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
            
            var db: OpaquePointer?
            
            if sqlite3_open(finalDatabaseURL.path, &db) != SQLITE_OK{
                print("error opening database")
                return
            }
            
            readLocations(db: db!)
            
            addLocation(db: db!)
            
            readLocations(db: db!)
            
            removeLocations(db: db!)
            
            readLocations(db: db!)
        }
    }
    
    
    func readLocations(db: OpaquePointer)
    {
        let queryStr = "SELECT * FROM locations"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error reading : \(errMsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let tid = sqlite3_column_int(stmt, 0)
            let lat = sqlite3_column_double(stmt, 1)
            let lon = sqlite3_column_double(stmt, 2)
            print(tid, lat, lon)
        }
        
        print("_______")
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

