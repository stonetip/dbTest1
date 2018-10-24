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
    
    var dataSource: LocationsDataSource?
    

    
    func readValues(){
        
        
        let locations = [Locations(lid: 1, tid: 3,
                                   location: CLLocation(coordinate: CLLocationCoordinate2DMake(46, -112),
                                                        altitude: 1234,
                                                        horizontalAccuracy: 10,
                                                        verticalAccuracy: 15,
                                                        course: 32.54321,
                                                        speed: 1.7,
                                                        timestamp: Date())
            ), Locations(lid: 2, tid: 3,
                         location: CLLocation(coordinate: CLLocationCoordinate2DMake(46.123456, -112.654321),
                                              altitude: 1261,
                                              horizontalAccuracy: 10,
                                              verticalAccuracy: 15,
                                              course: 34.54321,
                                              speed: 1.6,
                                              timestamp: Date())
            )]
        
        //        self.dataSource = LocationsDataSource(locs: locations)
        //        super.init(coder: aDecoder)
        
        var locations2 = [Locations]()
        
        do{
            try dbQueue?.read { db in
                //let locations2 =  try Row.fetchAll(db, "SELECT * FROM locations")
                locations2 = try Locations.fetchAll(db)
                for location in locations2{
                    
                    print(location)
                }
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
        self.dataSource = LocationsDataSource(locs: locations2)
    
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readValues()

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



