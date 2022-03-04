//
//  HomeView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 17/01/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        TabView {
            NavigationView {
                NewsView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("News")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("News", systemImage: "newspaper")
            }
            .tag(0)

            NavigationView {
                CircleListView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Circles")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Circles", systemImage: "circle.hexagonpath")
            }.tag(1)

            NavigationView {
                MyCircleView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("My Circle")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("My Circle", systemImage: "circle.hexagongrid.circle")
            }.tag(2)

            NavigationView {
                ShopView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Shop")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Shop", systemImage: "cart")
            }.tag(3)

            NavigationView {
                MoreView()
                    .environmentObject(settings)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("More")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("More", systemImage: "filemenu.and.selection")
            }.tag(4)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(UserSettings())
        }
    }
}
