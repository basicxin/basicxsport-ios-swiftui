//
//  TournamentLocationMapView.swift
//  BasicxSport
//
//  Created by Somesh K on 23/03/22.
//

import MapKit
import SwiftUI

struct TournamentLocationMapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: -0.0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    var location: Location

    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                region.center.longitude = location.longitude
                region.center.latitude = location.latitude
            }
            .navigationTitle(location.name)
    }
}

struct TournamentLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        TournamentLocationMapView(location: Location(id: 0, name: "London", latitude: 51.507222, longitude: -0.1275))
    }
}
