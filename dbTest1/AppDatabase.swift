//
//  AppDatabase.swift
//  dbTest1
//
//  Created by Jonathan Nehring on 10/14/18.
//  Copyright © 2018 stonetip. All rights reserved.
//
import CoreLocation
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
        
        let dbURL = appSupportDirUrls.first!.appendingPathComponent(dbName)
        
        if !( (try? dbURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in app support folder")
            return
        } else {
            print("DB file found at path: \(dbURL.path)")
            
            do{
                try fileManager.removeItem(at: dbURL)
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
        
        let dbFileDest = appSupportDirUrls.first!.appendingPathComponent(dbName, isDirectory: false)
        
        if !( (try? dbFileDest.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in app support folder")
            
            let dbFileSrc = Bundle.main.resourceURL?.appendingPathComponent(dbName)
            
            do {
                try fileManager.copyItem(atPath: (dbFileSrc?.path)!, toPath: dbFileDest.path)
                print("DB copied over to \(dbFileDest.path)")
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
        } else {
            print("Database file found at path: \(dbFileDest.path)")
        }
    }
    
    
    /// Creates a fully initialized database at path
    static func openDatabase(dbName: String) throws -> DatabaseQueue {
        
        let fileManager = FileManager.default
        
        let appSupportDirUrls = fileManager.urls(for: .applicationSupportDirectory,
                                                 in: .userDomainMask)
        
        let dbURL = appSupportDirUrls.first!.appendingPathComponent(dbName, isDirectory: false)
        print(dbURL.path)
        
        dbQueue = try DatabaseQueue(path: dbURL.path)
        
        return dbQueue
    }
    
    
    
    static func insertTrackRecord() -> (insertSuccessful: Bool, tid: Int64){
        
        var insertSuccessful: Bool = false
        var tid: Int64 = 0
        
        do{
            try dbQueue.inDatabase{db in
                
                // First, set all other tracks's currentTrack value to false
                try db.execute("UPDATE tracks SET currentTrack = :val", arguments: ["val": false])
                
                
                var newTrack = Tracks(tid: nil,
                                      uuid: UUID().uuidString.lowercased(),
                                      name: "",
                                      dateCreated: Date(),
                                      dateModified: Date(),
                                      currentTrack: true,
                                      uploaded: false)
                
                try newTrack.insert(db)
                
                print("newTrack ID: \(newTrack.tid ?? 0)")
                
                tid = newTrack.tid ?? 0
                insertSuccessful = true
                
                let trackCheck = try Tracks.fetchAll(db)
                for track in trackCheck{
                    print(track)
                }
                
                print("***********************")
                
                
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
        return (insertSuccessful, tid)
    }
    
    // Note: There's always going to be a tid (track ID) but lids (location IDs) may not be associated with a note. This will allow easy selection of all notes related to a track.
    static func insertNoteRecord(currentTrackID: Int64, note: String, locationID: Int64?)-> Bool{
        var insertSuccessful: Bool = false
        
        do{
            try dbQueue.inDatabase{db in
                
                var newNote = Notes(note: note,
                                    tid: currentTrackID,
                                    lid: locationID,
                                    timeStamp: Date()
                )
                try newNote.insert(db)
                
                // check
                let notesRequest = Notes.filter(sql: "tid = ?", arguments: [currentTrackID])
                let notesCheck = try notesRequest.fetchAll(db)
                for note in notesCheck{
                    print(note)
                }
                
                insertSuccessful = true
            }
        }
        catch let error as NSError{
            print(error.debugDescription)
        }
        
        return insertSuccessful
    }
    
    
    static func insertLocationRecord(currentTrackID: Int64, inputLocation: CLLocation) -> Bool{
        
        var insertSuccessful: Bool = false
        
        do{
            try dbQueue.inDatabase{db in
                
                var newLocation = Locations(lid: nil,
                                            tid: currentTrackID,
                                            location: inputLocation
                )
                
                try newLocation.insert(db)
                
                insertSuccessful = true
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
        return insertSuccessful
    }
    
}

