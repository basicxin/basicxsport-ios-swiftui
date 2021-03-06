//
//  MyMatchesView.swift
//  BasicxSport
//
//  Created by Somesh K on 17/03/22.
//

import Kingfisher
import SwiftUI

struct MyMatchesView: View {
    @StateObject private var viewModel = MyMatchesViewModel()
    @State private var currentPage = 0
    let myMatchesType = [Constants.Matches.MATCH_STATUS_OPEN, Constants.Matches.MATCH_STATUS_IN_PLAY, Constants.Matches.MATCH_STATUS_COMPLETED]
    var body: some View {
        VStack {
            PagerTabView(currentPage: $currentPage, myMatchesType: myMatchesType)

            PagerView(pageCount: myMatchesType.count, currentIndex: $currentPage) {
//                ForEach(myMatchesType, id: \.self) { matchType in
//                    MyMatchView(matchType: matchType, viewModel: viewModel)
//                }

                MyMatchView(matchType: myMatchesType[0], matchList: viewModel.upcomingMatches).onAppear {
                    viewModel.getMyMatches(matchType: myMatchesType[0])
                }
                MyMatchView(matchType: myMatchesType[1], matchList: viewModel.inPlayMatches).onAppear {
                    viewModel.getMyMatches(matchType: myMatchesType[1])
                }
                MyMatchView(matchType: myMatchesType[2], matchList: viewModel.completedMatches).onAppear {
                    viewModel.getMyMatches(matchType: myMatchesType[2])
                }
            }
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
        .navigationTitle("My Matches")
    }
}

struct MyMatchView: View {
    var matchType: String = ""
    var matchList: [Match]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if !matchList.isEmpty {
                    List(matchList, id: \.self) { myMatch in

                        HStack(spacing: 0) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(myMatch.matchName).fontWeight(.light).textCase(.uppercase).font(.caption)
                                    Spacer()
                                    Text(myMatch.status).fontWeight(.light).textCase(.uppercase).font(.caption)
                                }

                                if myMatch.matchType == Constants.Tournament.MATCH_FORMAT_DOUBLE {
                                    if myMatch.team1 != nil, myMatch.team1!.players.count == 2 {
                                        HStack {
                                            VStack {
                                                PlayerNameImageView(imageUrl: myMatch.team1!.players[0].profilePictureUrl, name: myMatch.team1!.players[0].name)

                                                PlayerNameImageView(imageUrl: myMatch.team1!.players[1].profilePictureUrl, name: myMatch.team1!.players[1].name)
                                            }

                                            Spacer()

                                            if myMatch.winner != nil, myMatch.winner!.id == myMatch.team1!.id {
                                                Image(systemName: "crown")
                                            }
                                        }
                                    }

                                    if myMatch.team2 != nil,  myMatch.team2!.players.count == 2 {
                                        HStack {
                                            VStack {
                                                PlayerNameImageView(imageUrl: myMatch.team2!.players[0].profilePictureUrl, name: myMatch.team2!.players[0].name)

                                                PlayerNameImageView(imageUrl: myMatch.team2!.players[1].profilePictureUrl, name: myMatch.team2!.players[1].name)
                                            }

                                            Spacer()

                                            if myMatch.winner != nil, myMatch.winner!.id == myMatch.team2!.id {
                                                Image(systemName: "crown")
                                            }
                                        }
                                    }
                                }
                                
                                else {
                                    if myMatch.team1 != nil {
                                        HStack {
                                            if myMatch.team1!.seatType == Constants.Tournament.SEAT_TYPE_SINGLE {
                                                PlayerNameImageView(imageUrl: myMatch.team1!.players[0].profilePictureUrl, name: myMatch.team1!.players[0].name)
                                            } else {
                                                PlayerNameImageView(imageUrl: myMatch.team1!.teamLogoUrl, name: myMatch.team1!.name)
                                            }

                                            Spacer()

                                            if myMatch.winner != nil, myMatch.winner!.id == myMatch.team1!.id {
                                                Image(systemName: "crown")
                                            }
                                        }
                                    }

                                    if myMatch.team2 != nil {
                                        HStack {
                                            if myMatch.team2!.seatType == Constants.Tournament.SEAT_TYPE_SINGLE {
                                                PlayerNameImageView(imageUrl: myMatch.team2!.players[0].profilePictureUrl, name: myMatch.team2!.players[0].name)
                                            } else {
                                                PlayerNameImageView(imageUrl: myMatch.team2!.teamLogoUrl, name: myMatch.team1!.name)
                                            }

                                            Spacer()

                                            if myMatch.winner != nil, myMatch.winner!.id == myMatch.team2!.id {
                                                Image(systemName: "crown")
                                            }
                                        }
                                    }
                                }

                                Text(Date(milliseconds: Int64(myMatch.startTime))
                                    .getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_TIME_FORMAT))
                                    .font(.caption)

                            }.frame(width: 0.65 * geometry.size.width)

                            ScrollView(.horizontal) {
                                HStack {
                                    if myMatch.isBye {
                                        Text("Bye")
                                            .bold()
                                            .padding(5)
                                            .background(.quaternary)
                                            .foregroundColor(.green)
                                            .font(.headline)
                                            .rotationEffect(Angle(degrees: 25.0))
                                    } else {
                                        ForEach(myMatch.sets, id: \.self) { sets in
                                            VStack {
                                                Text(sets.setNo.string).font(.subheadline).fontWeight(.light)
                                                Spacer()
                                                Spacer()

                                                Text(sets.playerAScore.string).fontWeight(.light)
                                                Spacer()
                                                Spacer()

                                                Text(sets.playerBScore.string).fontWeight(.light)
                                                Spacer()
                                                Spacer()
                                            }
                                            .padding(.horizontal, 5)
                                            .fullHeight()
                                            .background(.quaternary)
                                        }
                                    }
                                }
                            }.frame(width: 0.35 * geometry.size.width).padding(.leading, 10)
                        }.fullWidth(alignement: .leading)

                    }.listStyle(.plain)
                } else {
                    Text("No \(matchType.lowercased()) matches available right now")
                }
            }
            .fullSize(alignement: .center)
        }
    }
}


struct PagerTabView: View {
    @Binding var currentPage: Int
    var myMatchesType: [String]
    var body: some View {
        HStack {
            ForEach(0 ..< myMatchesType.count, id: \.self) { index in
                if currentPage == index {
                    Text(myMatchesType[index]).font(.title2).padding(5)
                } else {
                    Text(myMatchesType[index]).fontWeight(.light).padding(5).onTapGesture {
                        currentPage = index
                    }
                    .transition(.scale)
                }
            }
        }
        .fullWidth(alignement: .leading)
        .padding()
    }
}

struct PlayerNameImageView: View {
    
    var imageUrl: String
    var name: String
    
    var body: some View {
        HStack {
            KFImage(URL(string: imageUrl))
                .placeholder {
                    DefaultPlaceholder()
                }
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            Text(name).fontWeight(.light).font(.subheadline)
        }
    }
}

struct MyMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MyMatchesView()
    }
}
