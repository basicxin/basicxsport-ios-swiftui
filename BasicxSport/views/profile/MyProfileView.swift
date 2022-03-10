//
//  MyProfileView.swift
//  BasicxSport
//
//  Created by Somesh K on 01/03/22.
//

import Kingfisher
import SwiftUI

struct MyProfileView: View {
    @State var moveToOrderHistoryView = false
    @State var moveToDocumentView = false
    @State var moveToEditProfileView = false
    @State var moveToAddressView = false

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Group {
                NavigationLink(destination: OrderHistoryView(), isActive: $moveToOrderHistoryView) { EmptyView() }
                NavigationLink(destination: DocumentListView(), isActive: $moveToDocumentView) { EmptyView() }
                NavigationLink(destination: EditProfileView(), isActive: $moveToEditProfileView) { EmptyView() }
                NavigationLink(destination: AddressListView(), isActive: $moveToAddressView) { EmptyView() }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Hello,").fontWeight(.light)
                    Text(UserDefaults.userFirstName).font(.title)
                }
                Spacer()
                KFImage(URL(string: UserDefaults.profilePictureUrl))
                    .placeholder {
                        DefaultPlaceholder()
                    }
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(SwiftUI.Circle())
                    .clipped()
            }

            HStack {
                OptionRow(profileOption: ProfileOptions(optionName: "Profile", optionImage: "person.text.rectangle", optionDesc: "Change your personal information")).onTapGesture {
                    moveToEditProfileView = true
                }

                OptionRow(profileOption: ProfileOptions(optionName: "Documents", optionImage: "doc.richtext", optionDesc: "Add or delete documents")).onTapGesture {
                    moveToDocumentView = true
                }
            }

            HStack {
                OptionRow(profileOption: ProfileOptions(optionName: "Order History", optionImage: "cart", optionDesc: "Check your purchase history")).onTapGesture {
                    moveToOrderHistoryView = true
                }

                OptionRow(profileOption: ProfileOptions(optionName: "Address", optionImage: "house", optionDesc: "Change or add the address")).onTapGesture {
                    moveToAddressView = true
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("My Profile")
    }
}

struct OptionRow: View {
    var profileOption: ProfileOptions
    var body: some View {
        VStack {
            Text(profileOption.optionName)

            Image(systemName: profileOption.optionImage)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .center)

            Text(profileOption.optionDesc)
                .font(.system(size: 11))
                .fontWeight(.light)
                .textCase(.uppercase)
                .padding(5)
        }
        .frame(width: 160, height: 160, alignment: .center)
        .withDefaultShadow()
    }
}

struct ProfileOptions: Hashable {
    let optionName, optionImage, optionDesc: String
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyProfileView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
