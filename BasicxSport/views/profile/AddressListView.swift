//
//  AddressListView.swift
//  BasicxSport
//
//  Created by Somesh K on 09/03/22.
//

import SwiftUI

struct AddressListView: View {
    @StateObject private var viewModel = AddressViewModel()

    @State private var moveToNewAddressDetailView = false
    @State private var moveToEditAddressDetailView = false
    @State var selectedAddress: Address?

    var body: some View {
        VStack {
            Group {
                NavigationLink(destination: AddressDetailView(), isActive: $moveToNewAddressDetailView) { EmptyView() }
                NavigationLink(destination: AddressDetailView(address: selectedAddress!), isActive: $moveToEditAddressDetailView) { EmptyView() }
            }

            VStack {
                Label("Add Address", systemImage: "plus").onTapGesture {
                    moveToNewAddressDetailView = true
                }
            }
            if viewModel.addressList != nil, viewModel.addressList!.isEmpty != true {
                List(viewModel.addressList!, id: \.self) { address in
                    VStack {
                        HStack {
                            VStack {
                                Text(viewModel.getFullAddress(address: address)).multilineTextAlignment(.leading).fullWidth(alignement: .leading)
                            }
                            VStack {
                                if !address.addressType.isNilOrEmpty {
                                    Text(address.addressType!).font(.callout).padding(5).background(Color.secondarySystemBackground).cornerRadius(6)
                                }
                                if address.isPrimary {
                                    Text("Default").font(.callout).padding(5).background(.green).foregroundColor(.white).cornerRadius(6)
                                }
                            }
                        }.padding(.bottom, 10)

                        HStack {
                            Text("Edit").onTapGesture {
                                selectedAddress = address
                                moveToEditAddressDetailView = true
                            }
                            if !address.isPrimary {
                                Spacer()
                                Text("Set Default").onTapGesture {
                                    viewModel.makeDefaultAddress(objectId: address.id) {
                                        viewModel.getAddresses()
                                    }
                                }
                                Spacer()
                                Text("Remove").onTapGesture {
                                    viewModel.deleteAddresses(objectId: address.id) {
                                        viewModel.getAddresses()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .listStyle(.plain)
                .navigationTitle("Addresses")
            } else {
                Spacer()
                Text("No Adresses Found")
                Spacer()
            }
        }
        .fullWidth(alignement: .top)
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
        .onAppear {
            viewModel.getAddresses()
        }
    }
}

struct AddressListView_Previews: PreviewProvider {
    static var previews: some View {
        AddressListView()
    }
}
