//
//  ViewController.swift
//  dbTest1
//
//  Created by Jonathan Nehring on 10/11/18.
//  Copyright © 2018 stonetip. All rights reserved.
//

import UIKit
import GRDB
import CoreLocation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    let dataSource: LocationsDataSource
    
    required init?(coder aDecoder: NSCoder){
        
        let locations = [LocationVals(lid: 4, tid: 7, lat: 46.0, lon: -112.0, alt: 1234.0, horizAccuracy: 10.0, vertAccuracy: 5.0, speed: 1.2, course: 301.2, timeStamp: "2018-10-23 18:08:29.043"),
                         LocationVals(lid: 5, tid: 7, lat: 46.1, lon: -112.2, alt: 1259.0, horizAccuracy: 10.0, vertAccuracy: 5.0, speed: 1.1, course: 278.8, timeStamp: "2018-10-23 24:18:29.043")]
        self.dataSource = LocationsDataSource(locations: locations)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        locationsTableView.estimatedRowHeight = 32
        locationsTableView.rowHeight = UITableView.automaticDimension
        locationsTableView.dataSource = dataSource
        locationsTableView.reloadData()
        
        
        
        print("Seeded table:")
        readLocationsValues()
        
        addLoc(for: 3)
        print("After record added:")
        readLocationsValues()
        
        removeLocs(for: 2)
        print("After track and foreign-key related locations deleted:")
        readLocationsValues()
        
        do{
            try dbQueue.inDatabase{db in
                
                var newLocation = Locations(lid: 0, tid: 3,
                                    location: CLLocation(coordinate: CLLocationCoordinate2DMake(46, -112),
                                                         altitude: 1234,
                                                         horizontalAccuracy: 10,
                                                         verticalAccuracy: 15,
                                                         course: 32.54321,
                                                         speed: 1.7,
                                                         timestamp: Date())
                )
                
                try newLocation.insert(db)
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
        readLocationsValues()
        
        // Testing a track insert
        do{
            try dbQueue.inDatabase{db in
                
                var newTrack = Tracks(tid: nil,
                                      uuid: UUID().uuidString.lowercased(),
                                      name: "Test Track 4",
                                      dateCreated: Date(),
                                      dateModified: Date(),
                                      currentTrack: false,
                                      uploaded: false)
                
                try newTrack.insert(db)
                
                
                let trackCheck = try Tracks.fetchAll(db)
                for track in trackCheck{
                    print(track)
                }
                
                print("***********************")
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
        // Testing a track update
        do{
            try dbQueue.inDatabase{db in
                
                if var latestTrack = try Tracks.fetchOne(db, key: 4)
                {
                    latestTrack.currentTrack = true
                    try latestTrack.update(db)
                }
                
                let trackCheck = try Tracks.fetchAll(db)
                for track in trackCheck{
                    print(track)
                }
                
                print("***********************")
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    
    func readLocationsValues(){
        
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
    
    // NOTE: This is more the old-school raw SQL way of doing things
    func addLoc(for tid: Int)
    {
        do{
            try dbQueue.write{db in
                try db.execute("INSERT INTO locations VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", arguments: [nil, tid, 46.123456, -112.654321, 1234.0, 5.0, 5.0, 1.0, 10.0, Date()])
            }
        }catch let error as NSError {
            print("Couldn't insert record! Error:\(error.description)")
        }
    }
    
    // NOTE: This is an example of either using raw SQL or alternately the row ID
    func removeLocs(for tid: Int)
    {
        do{
//            try dbQueue?.write{db in
//               try db.execute("DELETE FROM tracks WHERE tid = ?", arguments: [tid])
//            }
            let deleteOp = try dbQueue.write{db in
                
                try Tracks.deleteOne(db, key: tid)
            }
            print("+++++++++++++++++++++++++++")
            print(deleteOp)
            
        }catch let error as NSError {
            print("Couldn't delete record(s)! Error:\(error.description)")
        }
    }
}



