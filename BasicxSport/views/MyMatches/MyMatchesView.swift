//
//  MyMatchesView.swift
//  BasicxSport
//
//  Created by Somesh K on 17/03/22.
//

import SwiftUI

struct MyMatchesView: View {
    @State private var currentPage = 0
    let myMatchesType = ["Upcoming", "In-Play", "Completed"]
    var body: some View {
        VStack {
            PagerTabView(currentPage: $currentPage, myMatchesType: myMatchesType)

            PagerView(pageCount: myMatchesType.count, currentIndex: $currentPage) {
                ForEach(myMatchesType, id: \.self) { matchType in
                    MyMatchView(matchType: matchType)
                }
            }
        }
    }
}

struct MyMatchView: View {
    var matchType: String = ""
    var body: some View {
        GeometryReader { geometry in
            List(1 ..< 5) { _ in

                HStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Final Champions League").fontWeight(.light).textCase(.uppercase).font(.footnote)
                            Spacer()
                            Text("In-Play").fontWeight(.light).textCase(.uppercase).font(.footnote)
                        }

                        HStack {
                            Image("basicxPlaceholder").resizable().frame(width: 50, height: 50)
                            Text("Somesh Kumar")
                            Spacer()
                            Image(systemName: "crown")
                        }

                        HStack {
                            Image("basicxPlaceholder").resizable().frame(width: 50, height: 50)
                            Text("Akanksha Kasana")
                            Spacer()
                            Image(systemName: "crown")
                        }

                        Text("Sep 4, 2019 7:13:00 AM").font(.caption)

                    }.frame(width: 0.65 * geometry.size.width)

                    ScrollView(.horizontal) {
                        HStack {
                            VStack {
                                Text("1").font(.subheadline)
                                Spacer()
                                Spacer()

                                Text("10")
                                Spacer()
                                Spacer()

                                Text("8")
                                Spacer()
                                Spacer()
                            }
                            .padding(.horizontal, 5)
                            .fullHeight()
                            .background(.quaternary)
                        }

                    }.frame(width: 0.35 * geometry.size.width).padding(.leading, 10)
                }.fullWidth(alignement: .leading)

            }.listStyle(.plain)
        }
    }
}

struct MyMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MyMatchesView()
    }
}

struct PagerTabView: View {
    @Binding var currentPage: Int
    var myMatchesType: [String]
    var body: some View {
        HStack {
            ForEach(0 ..< myMatchesType.count, id: \.self) { index in
                if currentPage == index {
                    Text(myMatchesType[index]).font(.title).padding(5)
                } else {
                    Text(myMatchesType[index]).padding(5).onTapGesture {
                        currentPage = index
                    }
                }
            }
        }
        .fullWidth(alignement: .leading)
        .padding()
    }
}
