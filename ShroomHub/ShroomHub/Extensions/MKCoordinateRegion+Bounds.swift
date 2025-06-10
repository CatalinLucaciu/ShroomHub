//
//  MKCoordinateRegion+Bounds.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 07.06.2025.
//
import MapKit

extension MKCoordinateRegion {
    static func region(
        for coordinates: [CLLocationCoordinate2D],
        fallback: CLLocationCoordinate2D,
        defaultSpan: CLLocationDegrees = 3.0,
        edgePadding: CGFloat = 0.2
    ) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
            return MKCoordinateRegion(
                center: fallback,
                span: MKCoordinateSpan(latitudeDelta: defaultSpan, longitudeDelta: defaultSpan)
            )
        }

        var minLat = coordinates.first!.latitude
        var maxLat = coordinates.first!.latitude
        var minLon = coordinates.first!.longitude
        var maxLon = coordinates.first!.longitude

        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let latDelta = max(0.01, (maxLat - minLat) * (1.0 + edgePadding))
        let lonDelta = max(0.01, (maxLon - minLon) * (1.0 + edgePadding))

        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        )
    }
}
