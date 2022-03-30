//
//  AddressDetailView.swift
//  BasicxSport
//
//  Created by Somesh K on 11/03/22.
//

import SwiftUI

struct AddressDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showStateSheet = false
    @State private var showDistrictSheet = false

    @StateObject private var viewModel = AddressViewModel()
    var isEditMode = false
    var address: Address?
    init() {
        self.isEditMode = false
    }

    init(address: Address) {
        self.isEditMode = true
        self.address = address
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Address Type").font(.subheadline).fontWeight(.light)

                Picker(selection: $viewModel.addressType, label: Text("Type")) {
                    Text("Home").tag("Home")
                    Text("Office").tag("Office")
                    Text("Other").tag("Other")
                }.pickerStyle(.segmented)

                Spacer()

                Text("Flat/ House No. / Colony / Street / Locality").font(.subheadline).fontWeight(.light)

                TextEditor(text: $viewModel.streetAddress)
                    .frame(width: .infinity, height: 100)
                    .padding([.leading, .trailing], 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.systemGray5), lineWidth: 1.0)
                    )

                Spacer()

                Group {
                    Text("Country").font(.subheadline).fontWeight(.light) + Text("*").foregroundColor(.red)
                    Picker(selection: $viewModel.country, label: Text("Country")) {
                        Text(Constants.DEFAULT_COUNTRY_NAME)
                    }
                    Divider()

                    Text("State").font(.subheadline).fontWeight(.light) + Text("*").foregroundColor(.red)
                    Text(viewModel.selectedState).onTapGesture {
                        viewModel.getStates {
                            showStateSheet = true
                        }
                    }

                    Divider()

                    Text("District").font(.subheadline).fontWeight(.light) + Text("*").foregroundColor(.red)
                    Text(viewModel.selectedDistrict).onTapGesture {
                        if viewModel.selectedStateId != -1 {
                            viewModel.getDistricts(withStateId: viewModel.selectedStateId) {
                                showDistrictSheet = true
                            }
                        }
                    }

                    Divider()
                }

                Group {
                    Text("City").font(.subheadline).fontWeight(.light)
                    TextField("City", text: $viewModel.city).padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(.systemGray5), lineWidth: 1.0)
                        )

                    Text("Postal/Zip Code").font(.subheadline).fontWeight(.light)
                    TextField("Postal", text: $viewModel.postalCode).padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(.systemGray5), lineWidth: 1.0)
                        )
                }
            }
        }
        .padding()
        .sheet(isPresented: $showStateSheet) {
            StateSheet(geographicList: viewModel.states).environmentObject(viewModel)
        }
        .sheet(isPresented: $showDistrictSheet) {
            DistrictSheet(geographicList: viewModel.districts).environmentObject(viewModel)
        }
        .onAppear {
            if let savedAddress = address {
                viewModel.addressType = savedAddress.addressType!
                viewModel.streetAddress = savedAddress.streetAddress!
                viewModel.city = savedAddress.city!
                viewModel.postalCode = savedAddress.postalCode!
                viewModel.country = Constants.DEFAULT_COUNTRY_NAME

                if let savedState = savedAddress.state {
                    viewModel.selectedState = savedState.name
                    viewModel.selectedStateId = savedState.id
                }
                if let savedDistrict = savedAddress.district {
                    viewModel.selectedDistrict = savedDistrict.name
                    viewModel.selectedDistrictId = savedDistrict.id
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEditMode {
                        viewModel.updateAddress(countryId: Constants.DEFAULT_COUNTRY_ID, stateId: viewModel.selectedStateId, districtId: viewModel.selectedDistrictId, city: viewModel.city, postalCode: viewModel.postalCode, streetAddress: viewModel.streetAddress, addressType: viewModel.addressType, addressId: address!.id) {
                            dismiss()
                        }
                    } else {
                        viewModel.addAddress(countryId: Constants.DEFAULT_COUNTRY_ID, stateId: viewModel.selectedStateId, districtId: viewModel.selectedDistrictId, city: viewModel.city, postalCode: viewModel.postalCode, streetAddress: viewModel.streetAddress, addressType: viewModel.addressType) {
                            dismiss()
                        }
                    }
                } label: {
                    if isEditMode {
                        Text("Update")
                    } else {
                        Text("Add")
                    }
                }.disabled(!viewModel.canSubmitStep)
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
    }
}

struct StateSheet: View {
    @EnvironmentObject var viewModel: AddressViewModel
    @Environment(\.dismiss) var dismiss
    var geographicList: [Country]
    var body: some View {
        List {
            ForEach(geographicList, id: \.id) { geography in
                Text(geography.name)
                    .padding()
                    .onTapGesture {
                        viewModel.selectedState = geography.name
                        viewModel.selectedStateId = geography.id
                        dismiss()
                    }
            }
        }
    }
}

struct DistrictSheet: View {
    @EnvironmentObject var viewModel: AddressViewModel
    @Environment(\.dismiss) var dismiss
    var geographicList: [Country]
    var body: some View {
        List {
            ForEach(geographicList, id: \.id) { geography in
                Text(geography.name)
                    .padding()
                    .onTapGesture {
                        viewModel.selectedDistrict = geography.name
                        viewModel.selectedDistrictId = geography.id
                        dismiss()
                    }
            }
        }
    }
}

struct AddressDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AddressDetailView()
    }
}
