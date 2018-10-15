import CoreLocation
import GRDB

struct Locations {
    
    var tid: Int64
    var location: CLLocation
}

extension Locations: FetchableRecord{
    init(row: Row) {
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
    var notes: String?
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
        notes = row["notes"]
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
        container["notes"] = notes
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        tid = rowID
    }
}
