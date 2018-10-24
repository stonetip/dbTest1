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



class LocationsDataSource: NSObject{
    
    let locs: [Locations]
    init(locs: [Locations]){
        self.locs = locs
    }
}

extension LocationsDataSource: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationCell.self)) as! LocationCell
        let loc = locs[indexPath.row]
        
        cell.lid = loc.lid ?? 0
        cell.tid = loc.tid
        cell.lat = loc.location.coordinate.latitude
        cell.lon = loc.location.coordinate.longitude
        cell.alt = loc.location.altitude
        cell.horizAccuracy = loc.location.horizontalAccuracy
        cell.vertAccuracy = loc.location.verticalAccuracy
        cell.speed = loc.location.speed
        cell.course = loc.location.course
        cell.timeStamp = Formatter.iso8601.string(from: loc.location.timestamp)
        
        return cell
    }
}

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime, .withSpaceBetweenDateAndTime]
        return formatter
    }()
}
