import CoreLocation
import GRDB

struct Locations {
    var lid: Int64?
    var tid: Int64
    var location: CLLocation
}

extension Locations: FetchableRecord{
    init(row: Row) {
        lid = row["lid"]
        tid = row["tid"]
        location = CLLocation(coordinate: CLLocationCoordinate2DMake(row["lat"], row["lon"]),
                              altitude: row["altitude"],
                              horizontalAccuracy: row["horizontalAccuracy"],
                              verticalAccuracy: row["verticalAccuracy"],
                              course: row["course"],
                              speed: row["speed"],
                              timestamp: row["timeStamp"])
    }
}

extension Locations: MutablePersistableRecord{
    func encode(to container: inout PersistenceContainer) {
        container["lid"] = lid
        container["tid"] = tid
        container["lat"] = location.coordinate.latitude
        container["lon"] = location.coordinate.longitude
        container["altitude"] = location.altitude
        container["horizontalAccuracy"] = location.horizontalAccuracy
        container["verticalAccuracy"] = location.verticalAccuracy
        container["course"] = location.course
        container["speed"] = location.speed
        container["timeStamp"] = location.timestamp
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        lid = rowID
    }
}


/* TRACKS code */

struct Tracks{
    
    var tid: Int64?
    var uuid: String
    var name: String
    var dateCreated: Date?
    var dateModified: Date?
    var currentTrack: Bool
    var uploaded: Bool
}

extension Tracks: FetchableRecord{
    init(row: Row) {
        tid = row["tid"]
        uuid = row["uuid"]
        name = row["name"]
        dateCreated = row["dateCreated"]
        dateModified = row["dateModified"]
        currentTrack = row["currentTrack"]
        uploaded = row["uploaded"]
    }
}

extension Tracks: MutablePersistableRecord{
    func encode(to container: inout PersistenceContainer) {
        container["tid"] = tid
        container["uuid"] = uuid
        container["name"] = name
        container["dateCreated"] = dateCreated
        container["dateModified"] = dateModified
        container["currentTrack"] = currentTrack
        container["uploaded"] = uploaded
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        tid = rowID
    }
}


/* NOTES code */

struct Notes{
    
    var note: String
    var tid: Int64?
    var lid: Int64?
    var timeStamp: Date
}

extension Notes: FetchableRecord{
    
    init(row: Row) {
        note = row["note"]
        tid = row["tid"]
        lid = row["lid"]
        timeStamp = row["timeStamp"]
    }
}

extension Notes: MutablePersistableRecord{
    
    func encode(to container: inout PersistenceContainer) {
        container["note"] = note
        container["tid"] = tid
        container["lid"] = lid
        container["timeStamp"] = timeStamp
    }
}

