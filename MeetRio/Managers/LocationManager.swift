//
//  LocationManager.swift
//  MeetRio
//
//  Created by Felipe on 10/08/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    private let geocoder = CLGeocoder()

    func getCoordinates(for address: String) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                self.latitude = placemark.location?.coordinate.latitude
                self.longitude = placemark.location?.coordinate.longitude
            }
        }
    }
}
