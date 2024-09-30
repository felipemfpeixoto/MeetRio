//
//  MapView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 26/08/24.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var coordinate: CLLocationCoordinate2D
    var appleMapsURL: URL?
    
    @State var camera: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $camera) {
            Marker("", coordinate: coordinate)
        }
        //.frame(width: screenWidth * 0.85, height: screenHeight * 0.23)
        .mask(
            RoundedRectangle(cornerRadius: 30.0)
                //.frame(width: screenWidth * 0.85, height: screenHeight * 0.23)
        )
        .onAppear {
            setRegion(coordinate)
        }
        .onTapGesture {
            openAppleMaps()
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        camera = .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000))
    }
    
    private func openAppleMaps() {
        if let appleMapsURL {
            UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
        }
    }
    
    
    //MARK: TAMBÉM PODE SER ÚTIL, NÃO APAGAR
    //    private func openInAppleMaps(coordinate: CLLocationCoordinate2D, name: String) {
    //            let placemark = MKPlacemark(coordinate: coordinate)
    //            let mapItem = MKMapItem(placemark: placemark)
    //            mapItem.name = name
    //            mapItem.openInMaps(launchOptions: [
    //                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
    //            ])
    //        }
}
