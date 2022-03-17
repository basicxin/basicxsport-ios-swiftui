//
//  AddressDetailView.swift
//  BasicxSport
//
//  Created by Somesh K on 11/03/22.
//

import SwiftUI

struct AddressDetailView: View {
    @Environment(\.dismiss) var dismiss
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
                    Picker("State", selection: $viewModel.selectedStateIndex) {
                        ForEach(0 ..< viewModel.states.count, id: \.self) {
                            Text(self.viewModel.states[$0].name)
                        }
                    }.onChange(of: viewModel.selectedStateIndex) { newIndex in
                        viewModel.getDistricts(withStateId: viewModel.states[newIndex].id)
                    }

                    Divider()

                    Text("District").font(.subheadline).fontWeight(.light) + Text("*").foregroundColor(.red)
                    Picker("District", selection: $viewModel.selectedDistrictIndex) {
                        ForEach(0 ..< viewModel.districts.count, id: \.self) {
                            Text(self.viewModel.districts[$0].name)
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
        .onAppear {
            if address != nil {
                viewModel.addressType = address!.addressType!
                viewModel.streetAddress = address!.streetAddress!
                viewModel.city = address!.city!
                viewModel.postalCode = address!.postalCode!
                viewModel.country = Constants.DEFAULT_COUNTRY_NAME
            }
            viewModel.getStates()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEditMode {
                        viewModel.updateAddress(countryId: Constants.DEFAULT_COUNTRY_ID, stateId: viewModel.states[viewModel.selectedStateIndex].id, districtId: viewModel.districts[viewModel.selectedDistrictIndex].id, city: viewModel.city, postalCode: viewModel.postalCode, streetAddress: viewModel.streetAddress, addressType: viewModel.addressType, addressId: address!.id) {
                            dismiss()
                        }
                    } else {
                        viewModel.addAddress(countryId: Constants.DEFAULT_COUNTRY_ID, stateId: viewModel.states[viewModel.selectedStateIndex].id, districtId: viewModel.districts[viewModel.selectedDistrictIndex].id, city: viewModel.city, postalCode: viewModel.postalCode, streetAddress: viewModel.streetAddress, addressType: viewModel.addressType) {
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

struct AddressDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AddressDetailView()
    }
}
