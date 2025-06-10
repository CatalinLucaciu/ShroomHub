//
//  CollectedMushroom+Coordinates.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 07.06.2025.
//

import CoreLocation

extension CollectedMushroom {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: record.location.latitude,
            longitude: record.location.longitude
        )
    }
}
