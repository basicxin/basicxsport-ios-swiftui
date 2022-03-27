//
//  MyBadgeView.swift
//  BasicxSport
//
//  Created by Somesh K on 12/02/22.
//

import Kingfisher
import SwiftUI

struct MyBadgeView: View {
    @StateObject var viewModel = ProfileViewModel()
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.userBadge != nil {
                    let badge = viewModel.userBadge!
                    Image("basicxLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 100)

                    KFImage(URL(string: badge.member.profilePictureUrl))
                        .placeholder {
                            DefaultPlaceholder()
                        }
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(SwiftUI.Circle())
                        .padding(.bottom, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Name").fontWeight(.light).frame(width: 150, alignment: .leading)
                            Text("\(badge.member.firstName) \(badge.member.lastName)")
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .font(.body)
                        }

                        HStack {
                            Text("Gender").fontWeight(.light).frame(width: 150, alignment: .leading)
                            Text(badge.member.gender)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .font(.body)
                        }

                        HStack {
                            Text("DOB").fontWeight(.light).frame(width: 150, alignment: .leading)
                            Text(badge.member.dob)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .font(.body)
                        }

                        HStack {
                            Text("District").fontWeight(.light).frame(width: 150, alignment: .leading)
                            Text(badge.member.district.name)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .font(.body)
                        }
                    }

                    Spacer()

                    KFImage(URL(string: badge.member.qrCodeUrl))
                        .placeholder {
                            DefaultPlaceholder()
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    Text(badge.member.memberRegistrationId)
                }
            }
            .fullSize(alignement: .top)

        }.customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .alert(item: $viewModel.alert) { currentAlert in
            Alert(
                title: Text("Alert"),
                message: Text(currentAlert.message),
                dismissButton: .default(Text("Ok")) {
                    currentAlert.dismissAction?()
                }
            )
        }
        .onAppear {
            viewModel.getUserBadge()
        }
    }
}

struct MyBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        MyBadgeView()
    }
}
