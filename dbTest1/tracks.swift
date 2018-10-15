import CoreLocation
import GRDB

struct Locations {
    
    var tid: Int
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
