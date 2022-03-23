//
//  TournamentRulesView.swift
//  BasicxSport
//
//  Created by Somesh K on 23/03/22.
//

import SwiftUI
import WebKit
struct TournamentRulesView: View {
    @StateObject var viewModel = TournamentViewModel()
    var tournamentId: Int
    var body: some View {
            WebView(htmlText: $viewModel.tournamentRules)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .onAppear {
                    viewModel.getTournamentRules(tournamentId: tournamentId)
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
         
    }
}

struct WebView: UIViewRepresentable {
    @Binding var htmlText: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlText, baseURL: nil)
    }
}

struct TournamentRulesView_Previews: PreviewProvider {
    static var previews: some View {
        TournamentRulesView(tournamentId: 0)
    }
}

