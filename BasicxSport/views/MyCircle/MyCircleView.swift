//
//  MyCircleView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 17/01/22.
//

import Kingfisher
import SwiftUI

struct MyCircleView: View {
    @StateObject var viewModel = MyCircleViewModel()
    @State var showSwitchCircleSheet = false
    @State var showSwitchAccountSheet = false
    @State var showCircleDetailView = false
    @State var shouldShowMyProfileView = false
    @State var shouldShowAddChildAccoutView = false
    @StateObject var refresh = Events.shared
    var body: some View {
        ScrollView {
            Group {
                NavigationLink(destination: MyProfileView(), isActive: $shouldShowMyProfileView) { EmptyView() }

                NavigationLink(destination: RegistrationStep1View(isAddingChild: true), isActive: $shouldShowAddChildAccoutView)
                    { EmptyView() }
            }

            VStack {
                if viewModel.myCircleResponse != nil {
                    let myCircle = viewModel.myCircleResponse!

                    NavigationLink(destination: CircleInfoView(circle: SearchedCircles(id: myCircle.preferredCircle.id!, name: myCircle.preferredCircle.name, logoURL: myCircle.preferredCircle.logoURL, baseColor: myCircle.preferredCircle.baseColor)), isActive: $showCircleDetailView) { EmptyView() }

                    // MARK: User Card

                    HStack {
                        KFImage(URL(string: UserDefaults.profilePictureUrl))
                            .placeholder {
                                DefaultPlaceholder()
                            }
                            .resizable()
                            .frame(width: 60, height: 60, alignment: .center)
                            .scaledToFit()
                            .clipShape(SwiftUI.Circle())

                        Text("\(UserDefaults.userFirstName) \(UserDefaults.userLastName)")
                            .font(.subheadline)
                            .fullSize()
                            .padding(.horizontal)

                        Spacer()
                        Image(systemName: "chevron.down")
                            .padding()
                            .onTapGesture {
                                showSwitchAccountSheet = true
                            }
                        Image(systemName: "gear").onTapGesture {
                            shouldShowMyProfileView = true
                        }
                    }
                    .padding()
                    .frame(width: .infinity, height: 80, alignment: .center)
                    .withDefaultShadow()

                    // MARK: Circle Card

                    HStack {
                        KFImage(URL(string: myCircle.preferredCircle.logoURL))
                            .placeholder {
                                DefaultPlaceholder()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)

                        VStack {
                            HStack {
                                Text(myCircle.preferredCircle.name)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .fullWidth(alignement: .leading)

                                Image(systemName: "chevron.down").padding(.vertical).onTapGesture {
                                    showSwitchCircleSheet = true
                                }

                                Image(systemName: "info.circle").padding(.vertical).onTapGesture {
                                    showCircleDetailView = true
                                }
                            }
                            .fullSize(alignement: .top)

                            HStack {
                                Text("Members: \(myCircle.preferredCircle.membersCount.asStringOrZero())").font(.caption2).fontWeight(.light)
                                Spacer()
                                if myCircle.preferredCircle.joinedDate != nil {
                                    Text("Joined: \(Date(milliseconds: myCircle.preferredCircle.joinedDate!).getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_FORMAT))").font(.caption2).fontWeight(.light)
                                }
                            }
                        }
                        .fullSize(alignement: .topLeading)
                    }
                    .padding()
                    .frame(width: .infinity, height: 120, alignment: .center)
                    .withDefaultShadow()

                    // MARK: Feature Menu

                    if myCircle.preferredCircle.circleMemberData.subscriptionStatus.caseInsensitiveCompare(Constants.Circle.STATUS_ACTIVE) == .orderedSame {
                        NavigationLink {
                            TournamentListView()
                        } label: {
                            AppFeatureRow(imageName: "sportscourt", menuText: "Tournament")
                        }

                        NavigationLink {
                            GalleryListView()
                        } label: {
                            AppFeatureRow(imageName: "photo.on.rectangle", menuText: "Gallery")
                        }

                        NavigationLink {
                            MyMatchesView()
                        } label: {
                            AppFeatureRow(imageName: "gamecontroller", menuText: "My Matches")
                        }

                        NavigationLink {
                            MyWallView()
                        } label: {
                            AppFeatureRow(imageName: "line.horizontal.star.fill.line.horizontal", menuText: "My Wall")
                        }

                        NavigationLink {
                            MyBadgeView()
                        } label: {
                            AppFeatureRow(imageName: "sportscourt", menuText: "My badge")
                        }
                    }
                    else {
                        RenewCircleView(showCircleDetailView: $showCircleDetailView)
                    }
                }
            }
            .sheet(isPresented: $showSwitchCircleSheet) {
                if viewModel.myCircleResponse?.circles != nil {
                    SwitchCircleSheet(viewModel: viewModel, event: refresh)
                }
            }
            .sheet(isPresented: $showSwitchAccountSheet) {
                if viewModel.myCircleResponse?.circles != nil {
                    SwitchAccountSheet(viewModel: viewModel, shouldShowAddChildAccoutView: $shouldShowAddChildAccoutView)
                }
            }
        }
        .fullSize(alignement: .top)
        .onReceive(refresh.$newCirclePurchased, perform: { newCirclePurchased in
            if newCirclePurchased {
                viewModel.getMyCircle()
            }
        })
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
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
    }
}

struct SwitchCircleSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MyCircleViewModel
    @ObservedObject var event: Events
    var body: some View {
        VStack {
            let preferredCircle = viewModel.myCircleResponse!.preferredCircle
            Text("Switch Circle")
                .padding(.top)
            List(viewModel.myCircleResponse!.circles, id: \.self) { circle in
                HStack {
                    KFImage(URL(string: circle.logoURL))
                        .placeholder {
                            DefaultPlaceholder()
                        }
                        .resizable()
                        .frame(width: 50, height: 50)

                    Text(circle.name)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .font(.subheadline)

                    Spacer()
                    if preferredCircle.id == circle.id {
                        Image(systemName: "checkmark").foregroundColor(.green)
                    }
                }
                .onTapGesture {
                    viewModel.changePreferredCircle(circleId: circle.id) {
                        viewModel.getMyCircle()
                        event.myCircleChanged = true
                    }
                    dismiss()
                }
            }.listStyle(.inset)
        }
    }
}

struct SwitchAccountSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MyCircleViewModel
    @Binding var shouldShowAddChildAccoutView: Bool

    var body: some View {
        VStack {
            Text("Switch Account")
                .padding(.top)

            List(viewModel.myCircleResponse!.relations, id: \.self) { relation in
                HStack {
                    KFImage(URL(string: relation.profilePictureURL))
                        .placeholder {
                            DefaultPlaceholder()
                        }
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("\(relation.firstName) \(relation.lastName)")
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .font(.subheadline)

                    Spacer()
                    if UserDefaults.memberId == relation.id {
                        Image(systemName: "checkmark").foregroundColor(.green)
                    }
                }
                .onTapGesture {
                    saveUserDefault(relation: relation)
                    dismiss()
                }
            }.listStyle(.plain)

            Label("Add Account", systemImage: "plus")
                .padding()
                .fullWidth()
                .withDefaultShadow()
                .onTapGesture {
                    dismiss()
                    shouldShowAddChildAccoutView = true
                }
        }
    }

    func saveUserDefault(relation: Relation) {
        UserDefaults.memberId = relation.id
        UserDefaults.userFirstName = relation.firstName
        UserDefaults.userLastName = relation.lastName
        UserDefaults.profilePictureUrl = relation.profilePictureURL
        UserDefaults.relationshipType = relation.relationshipType
        UserDefaults.preferredSportId = relation.sport.id ?? -1
        UserDefaults.preferredSportName = relation.sport.name ?? ""
        UserDefaults.preferredSportLogoUrl = relation.sport.sportIconURL ?? ""
        viewModel.getMyCircle()
    }
}

struct AppFeatureRow: View {
    var imageName: String
    var menuText: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)

            Text(menuText)
                .padding(.horizontal)
                .fullWidth(alignement: .leading)
                .lineLimit(1)
        }

        .padding()
        .fullWidth(alignement: .leading)
        .withDefaultShadow()
    }
}

struct RenewCircleView: View {
    @Binding var showCircleDetailView: Bool
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
            Text("Your subscription for the circle has expired. Click on RENEW button to enjoy all the features.")
            Button {
                showCircleDetailView = true
            } label: {
                Text("Renew")
            }.buttonStyle(.borderedProminent)
        }
        .padding()
        .fullWidth()
        .withDefaultShadow()
    }
}

struct MyCircleView_Previews: PreviewProvider {
    static var previews: some View {
        MyCircleView()
    }
}
