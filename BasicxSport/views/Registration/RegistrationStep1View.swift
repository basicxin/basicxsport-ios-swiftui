//
//  ContentView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 10/01/22.
//

import Combine
import Kingfisher
import SwiftUI

struct RegistrationStep1View: View {
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var shouldMoveToNextView = false

    @StateObject private var viewModel = RegistrationViewModel()
    @EnvironmentObject var settings: UserSettings

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        GeometryReader { geometryReader in
            ScrollView {
                Group {
                    NavigationLink(destination: RegistrationStep2View()
                                    .environmentObject(viewModel)
                                    .environmentObject(settings), isActive: $shouldMoveToNextView) { EmptyView() }
                }
                VStack(alignment: .leading) {
                    Text("Choose State")
                    Picker("State", selection: $viewModel.selectedStateIndex) {
                        ForEach(0 ..< viewModel.states.count, id: \.self) {
                            Text(self.viewModel.states[$0].name)
                        }
                    }.onChange(of: viewModel.selectedStateIndex) { newIndex in
                        viewModel.getDistricts(withStateId: viewModel.states[newIndex].id)
                    }

                    Divider()

                    Text("Choose District")
                    Picker("District", selection: $viewModel.selectedDistrictIndex) {
                        ForEach(0 ..< viewModel.districts.count, id: \.self) {
                            Text(self.viewModel.districts[$0].name)
                        }
                    }.onChange(of: viewModel.selectedDistrictIndex) { newValue in
                        
                    }

                    Divider()

                    Text("Choose Prefered Sport")
                        .font(.title)
                        .bold()

                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(viewModel.sportsList, id: \.self) { sport in
                            SportChooserLayout(sport: sport, selectedSportId: $viewModel.selectedSportId)
                        }
                    }
                    Button {
                        shouldMoveToNextView = true
                    } label: {
                        Text("Next")
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.canSubmitStep1)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: geometryReader.size.height,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding()
                .navigationTitle("Registration (Step 1)")
                .navigationBarTitleDisplayMode(.inline)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .onAppear(perform: {
                viewModel.getStates()
                viewModel.getSportList()
            })
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

    func getDistricts(stateId: Int) {
        viewModel.getDistricts(withStateId: stateId)
    }
}

struct SportChooserLayout: View {
    let sport: SportsListSport
    @Binding var selectedSportId: Int?

    var body: some View {
        VStack {
            KFImage(URL(string: sport.sportIconURL)!)
                .placeholder {
                    DefaultPlaceholder()
                }
                .cancelOnDisappear(true)
                .resizable()
                .font(.system(size: 30))
                .frame(width: 50, height: 50)
                .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)
            Text(sport.name).multilineTextAlignment(.center).lineLimit(2)
        }
        .padding()
        .background(self.selectedSportId == sport.id ? Color.secondarySystemBackground : Color(UIColor.systemBackground))
        .withDefaultShadow()
        .onTapGesture {
            self.selectedSportId = sport.id
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RegistrationStep1View()
            }
            NavigationView {
                RegistrationStep1View()
            }
            .preferredColorScheme(.dark)
        }
    }
}
