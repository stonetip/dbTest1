//
//  AppDatabase.swift
//  dbTest1
//
//  Created by Jonathan Nehring on 10/14/18.
//  Copyright © 2018 stonetip. All rights reserved.
//

import GRDB

struct AppDatabase{
    
    
    // Delete a database from documents (basically for testing/dev purposes
    static func deleteDatabase(dbName: String){
        let fileManager = FileManager.default
        
        let appSupportDirUrls = fileManager.urls(for: .applicationSupportDirectory,
                                            in: .userDomainMask)
        
        guard appSupportDirUrls.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = appSupportDirUrls.first!.appendingPathComponent(dbName)
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in app support folder")
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
   static func copyDatabaseIfNeeded(dbName: String) {
        
        let fileManager = FileManager.default
        
        let appSupportDirUrls = fileManager.urls(for: .applicationSupportDirectory,
                                            in: .userDomainMask)
        
        guard appSupportDirUrls.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = appSupportDirUrls.first!.appendingPathComponent(dbName)
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in app support folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(dbName)
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
                print("DB copied over to app support folder")
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }
    
    
    /// Creates a fully initialized database at path
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        // Connect to the database
        // See https://github.com/groue/GRDB.swift/#database-connections
        dbQueue = try DatabaseQueue(path: path)
    
        return dbQueue
    }
}
