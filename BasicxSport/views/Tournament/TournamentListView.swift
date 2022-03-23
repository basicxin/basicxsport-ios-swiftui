//
//  TournamentListView.swift
//  BasicxSport
//
//  Created by Somesh K on 14/03/22.
//

import Kingfisher
import SwiftUI

struct TournamentListView: View {
    @StateObject private var viewModel = TournamentViewModel()
    var body: some View {
        ZStack {
            if !viewModel.tournamentList.isEmpty {
                List(viewModel.tournamentList, id: \.self) { tournament in
                    ZStack {
                        NavigationLink(destination: TournamentCategoryListView(tournamentId: tournament.id)) {}
                        TournamentView(tournament: tournament)
                    }
                }
                .listStyle(.plain)
            }
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.getTournaments(circleId: UserDefaults.preferredCircleId)
        }
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text("Alert"),
                message: Text(alert.message),
                dismissButton: .default(Text("Ok")) {
                    alert.dismissAction?()
                }
            )
        }
        .navigationTitle("Tournaments")
    }
}

struct TournamentView: View {
    var tournament: Tournament
    @State private var selectedLocation: Location? = nil
    @State private var selectedTournamentId: Int? = nil
    @State var shouldShowLocationView = false
    @State var shouldShowRulesView = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if let location = selectedLocation {
                    NavigationLink(destination: TournamentLocationMapView(location: location), isActive: $shouldShowLocationView) { EmptyView() }
                }
                
                if let tournamentId = selectedTournamentId {
                    NavigationLink(destination: TournamentRulesView(tournamentId: tournamentId), isActive: $shouldShowRulesView) { EmptyView()
                    }
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                KFImage(URL(string: tournament.bannerUrl))
                    .resizable()
                    .placeholder {
                        DefaultPlaceholder()
                    }
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                
                HStack {
                    Image(systemName: "calendar")
                        .padding(.trailing, 5)
                    
                    VStack(alignment: .leading) {
                        Text("Starts \(Date(milliseconds: tournament.startTime).getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_TIME_FORMAT))")
                            .font(.footnote)
                        
                        Text("Ends \(Date(milliseconds: tournament.endTime).getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_TIME_FORMAT))")
                            .font(.footnote)
                    }
                }
                
                Text(tournament.name)
                    .font(.headline)
                    .lineLimit(3)
                
                HStack {
                    if !tournament.locations.isNilOrEmpty {
                        Image(systemName: "location")
                       
                        Text(tournament.locations![0].name)
                            .lineLimit(1)
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(.foreground)
                            .cornerRadius(5)
                            .onTapGesture {
                                selectedLocation = tournament.locations!.first!
                                shouldShowLocationView = true
                            }
                    }
                    
                    Spacer()
                    
                    Text("Rules")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(.foreground)
                        .cornerRadius(5)
                        .onTapGesture {
                            selectedTournamentId = tournament.id
                            shouldShowRulesView = true
                        }
                }
                .fullWidth(alignement: .leading)
            }
            
            Text(tournament.status)
                .font(.footnote)
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
                .cornerRadius(5)
                .padding(5)
        }
        .padding(.bottom, 5)
    }
}

struct TournamentListView_Previews: PreviewProvider {
    static var previews: some View {
        TournamentListView()
    }
}
