//
//  CircleDetailView.swift
//  BasicxSport
//
//  Created by Somesh K on 03/02/22.
//

import Kingfisher
import SwiftUI

struct CircleInfoView: View {
    var circle: SearchedCircles
    @StateObject var viewModel = CircleInfoViewModel()
    @ObservedObject var cartViewModel = CartViewHolder()
    @State var shouldShowCartView = false
    var body: some View {
        GeometryReader { geometryReader in
            ScrollView {
                Group {
                    NavigationLink(destination: CartView(cartType: Constants.ITEM_TYPE_SUBSCRIPTION), isActive: $shouldShowCartView) { EmptyView() }
                }
                if viewModel.circleInfo != nil {
                    let circleInfo = viewModel.circleInfo!
                    VStack(spacing: 0) {
                        Rectangle().frame(height: geometryReader.safeAreaInsets.top).foregroundColor(Color(hex: circle.baseColor))

                        ZStack(alignment: .bottomLeading) {
                            Rectangle().frame(height: 80).foregroundColor(Color(hex: circle.baseColor))

                            HStack(alignment: .bottom) {
                                KFImage(URL(string: circle.logoURL))
                                    .placeholder {
                                        DefaultPlaceholder()
                                    }
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .withDefaultShadow()
                                    .padding(.leading)

                                Text(circle.name).lineLimit(2)
                            }
                            .fullWidth(alignement: .leading)
                            .alignmentGuide(.bottom) { d in d[.bottom] / 2 }
                        }

                        VStack(alignment: .leading) {
                            if !circleInfo.checklists.isEmpty {
                                Group {
                                    SmallHeader(text: "Required Documents")
                                    Text(circleInfo.checklistMessage).font(.caption2).padding(.bottom, 1)
                                    ForEach(circleInfo.checklists, id: \.self) { checklist in
                                        HStack {
                                            Text(checklist.notes).font(.callout)
                                            Spacer()

                                            if checklist.status == Constants.DocumentStatus.STATUS_ADDED {
                                                Label(checklist.status, systemImage: "checkmark")
                                                    .foregroundColor(.green)
                                                    .font(.subheadline)
                                            }

                                            else if checklist.status == Constants.DocumentStatus.STATUS_PENDING {
                                                if checklist.joiningChecklist.isMandatory {
                                                    NavigationLink(destination: AddDocumentView(identityType: checklist.joiningChecklist.identityType)) {
                                                        Label("Mandatory", systemImage: "plus")
                                                            .foregroundColor(.red)
                                                            .font(.subheadline)
                                                    }
                                                }
                                                else {
                                                    NavigationLink(destination: AddDocumentView(identityType: checklist.joiningChecklist.identityType)) {
                                                        Label("Pending", systemImage: "plus")
                                                            .foregroundColor(.gray)
                                                            .font(.subheadline)
                                                    }
                                                }
                                            }

                                            else if checklist.status == Constants.DocumentStatus.STATUS_VALID {
                                                NavigationLink(destination: AddDocumentView(identityType: checklist.joiningChecklist.identityType)) {
                                                    Label(checklist.status, systemImage: "checkmark")
                                                        .foregroundColor(.green)
                                                        .font(.subheadline)
                                                }
                                            }

                                            else if checklist.status == Constants.DocumentStatus.STATUS_REJECTED {
                                                NavigationLink(destination: AddDocumentView(identityType: checklist.joiningChecklist.identityType)) {
                                                    Label(checklist.status, systemImage: "xmark")
                                                        .foregroundColor(.red)
                                                        .font(.subheadline)
                                                }
                                            }

                                            else if checklist.status == Constants.DocumentStatus.STATUS_UNNEEDED {
                                                NavigationLink(destination: AddDocumentView(identityType: checklist.joiningChecklist.identityType)) {
                                                    Label("Optional", systemImage: "plus")
                                                        .foregroundColor(.gray)
                                                        .font(.subheadline)
                                                }
                                            }
                                        }
                                        .padding(.bottom, 1)
                                    }
                                    Divider()
                                }
                            }

                            Group {
                                SmallHeader(text: "About Circle")
                                Text(circleInfo.about).font(.callout)
                                Divider()
                            }

                            Group {
                                SmallHeader(text: "About Organisation")
                                Text(circleInfo.organizationName).font(.callout)
                                Divider()
                            }

                            Group {
                                SmallHeader(text: "Email Address")
                                Text(circleInfo.emailAddress).font(.callout)
                                Divider()
                            }

                            Group {
                                SmallHeader(text: "Contact Number")
                                Text(circleInfo.phoneNumber).font(.callout)
                                Divider()
                            }

                            if !circleInfo.subscriptions.isEmpty {
                                SmallHeader(text: "Subscriptions")
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(circleInfo.subscriptions, id: \.self) { subscription in

                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(subscription.name)
                                                    .fontWeight(.medium)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)

                                                Text(subscription.subscriptionDescription)
                                                    .font(.footnote)
                                                    .fontWeight(.light)
                                                    .lineLimit(4)
                                                    .multilineTextAlignment(.leading)
                                                    .fullWidth(alignement: .leading)

                                                Text("\(subscription.noOfDays.string) Days").fontWeight(.semibold)

                                                HStack {
                                                    Text(Constants.RUPEE + subscription.price.string)
                                                        .fontWeight(.bold)

                                                    Spacer()

                                                    Button {
                                                        if cartViewModel.isProductInCart {
                                                            shouldShowCartView = true
                                                        }
                                                        else {
                                                            cartViewModel.addToCart(objectId: subscription.id, itemType: Constants.ITEM_TYPE_SUBSCRIPTION) {
                                                                shouldShowCartView = true

                                                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                                                impactMed.impactOccurred()
                                                            }
                                                        }

                                                    } label: {
                                                        if cartViewModel.isProductInCart {
                                                            Text("Go to Cart")
                                                        }
                                                        else {
                                                            Text("BUY")
                                                        }
                                                    }
                                                    .buttonStyle(.borderedProminent)

                                                }.fullWidth()
                                            }
                                            .frame(minWidth: 250)
                                            .padding()
                                            .withDefaultShadow()
                                        }
                                    }
                                }
                                Divider()
                            }

                            if !circleInfo.representatives.isEmpty {
                                Group {
                                    SmallHeader(text: "Circle Representative")
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 10) {
                                            ForEach(circleInfo.representatives, id: \.self) { rep in
                                                HStack {
                                                    KFImage(URL(string: rep.profilePictureUrl))
                                                        .placeholder {
                                                            DefaultPlaceholder()
                                                        }
                                                        .resizable()
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(SwiftUI.Circle())

                                                    VStack(alignment: .leading, spacing: 2) {
                                                        Text(rep.name)

                                                        Text(rep.position).font(.callout).fontWeight(.light)

                                                        Text(rep.mobile).font(.callout).fontWeight(.light)
                                                    }
                                                    .padding(.leading, 10)
                                                }
                                                .padding()
                                                .withDefaultShadow()
                                            }
                                        }
                                    }
                                    Divider()
                                }
                            }
                        }
                        .padding()
                        .fullWidth(alignement: .leading)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .edgesIgnoringSafeArea(.top)
            .navigationTitle("Circle Info")
            .navigationBarTitleDisplayMode(.inline)
        }
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
        .onAppear {
            viewModel.getCirclesInfo(circleId: circle.id)
        }
    }
}

struct SmallHeader: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.footnote)
            .fullWidth()
            .padding(.vertical, 1)
            .background(.quaternary)
    }
}

struct CircleInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CircleInfoView(circle: SearchedCircles(id: 0, name: "", logoURL: "", baseColor: ""))
            }
        }
    }
}
