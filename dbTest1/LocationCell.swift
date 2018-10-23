//
//  locationsTable.swift
//  dbTest1
//
//  Created by Jonathan Nehring on 10/23/18.
//  Copyright © 2018 stonetip. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell{
    
    @IBOutlet weak var labelLID: UILabel!
    @IBOutlet weak var labelTID: UILabel!
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLon: UILabel!
    @IBOutlet weak var labelAlt: UILabel!
    @IBOutlet weak var labelHoriz: UILabel!
    @IBOutlet weak var labelVert: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelCourse: UILabel!
    @IBOutlet weak var labelTimeStamp: UILabel!
    
    var lid: Int64 = 2{
        didSet{
            labelLID.text = String(format: "%ld", lid )
        }
    }
    
    var tid: Int64 = 0{
        didSet{
            labelTID.text = String(format: "%ld", tid)
        }
    }
    
    var lat: Double = 0.0{
        didSet{
            labelLat.text = String(format: "%.5f", lat)
        }
    }
    
    var lon: Double = 0.0{
        didSet{
            labelLon.text = String(format: "%.5f", lon)
        }
    }
    
    var alt: Double = 0.0{
        didSet{
            labelAlt.text = String(format: "%.0f", alt)
        }
    }
    
    var horizAccuracy: Double = 0.0{
        didSet{
            labelHoriz.text = String(format: "%.0f", horizAccuracy)
        }
    }
    
    var vertAccuracy: Double = 0.0{
        didSet{
            labelVert.text = String(format: "%.0f", vertAccuracy)
        }
    }
    
    var speed: Double = 0.0{
        didSet{
            labelSpeed.text = String(format: "%.1f", speed)
        }
    }
    
    var course: Double = 0.0{
        didSet{
            labelCourse.text = String(format: "%.1f", course)
        }
    }
    
    var timeStamp: String? {
        didSet{
            labelTimeStamp.text = timeStamp
        }
    }
}

struct LocationVals{
    let lid: Int64
    let tid: Int64
    let lat: Double
    let lon: Double
    let alt: Double
    let horizAccuracy: Double
    let vertAccuracy: Double
    let speed: Double
    let course: Double
    let timeStamp: String
}

class LocationsDataSource: NSObject{
    
    let locations: [LocationVals]
    
    init(locations: [LocationVals]){
        self.locations = locations
    }
}

extension LocationsDataSource: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationCell.self)) as! LocationCell
        let location = locations[indexPath.row]
        cell.lid = location.lid
        cell.tid = location.tid
        cell.lat = location.lat
        cell.lon = location.lon
        cell.alt = location.alt
        cell.horizAccuracy = location.horizAccuracy
        cell.vertAccuracy = location.vertAccuracy
        cell.speed = location.speed
        cell.course = location.course
        cell.timeStamp = location.timeStamp
        
        return cell
    }
}
