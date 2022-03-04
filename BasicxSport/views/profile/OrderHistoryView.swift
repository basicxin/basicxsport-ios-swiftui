//
//  OrderHistoryView.swift
//  BasicxSport
//
//  Created by Somesh K on 02/03/22.
//

import Kingfisher
import SwiftUI

struct OrderHistoryView: View {
    @StateObject var viewModel = ProfileViewModel()

    var body: some View {
        VStack {
            InfiniteList(data: $viewModel.orders, isLoading: $viewModel.isLoading, loadMore: viewModel.getOrderHistory) { order in
                NavigationLink(destination: OrderHistoryDetailView(order: order)) {
                    OrderHistoryRow(order: order)
                }
            }
            .listStyle(.plain)
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
        .navigationBarTitle("Order History")
    }
}

struct OrderHistoryRow: View {
    var order: Order
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    KFImage(URL(string: order.circle.logoUrl))
                        .placeholder {
                            DefaultPlaceholder()
                        }
                        .resizable()
                        .clipShape(SwiftUI.Circle())
                        .frame(width: 50, height: 50)

                    Text(order.circle.name).fontWeight(.light).lineLimit(2).padding(.vertical, 5)
                }

                ForEach(order.itemList, id: \.self) { item in

                    if item.product != nil {
                        Text(item.product!.name).font(.headline).lineLimit(3).padding(.vertical, 2)
                    }
                    if item.subscription != nil {
                        Text(item.subscription!.name).font(.headline).lineLimit(3).padding(.vertical, 2)
                    }
                    if item.tournamentCategory != nil {
                        Text(item.tournamentCategory!.name).font(.headline).lineLimit(3).padding(.vertical, 2)
                    }
                }

                HStack {
                    Text("Invoice No.").fontWeight(.light)
                    Text(order.invoiceNo).lineLimit(2)
                }.padding(.vertical, 2)

                Text(Date(milliseconds: Int64(order.dateOfSale)).getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_TIME_FORMAT)).font(.body).fontWeight(.light).padding(.vertical, 2)

                Text(Constants.RUPEE + order.totalAmount.string).font(.title2).padding(.vertical, 2)
            }
            .fullWidth(alignement: .topLeading)

            if order.status != nil, !order.status!.isEmpty {
                if order.status!.uppercased() == "PAID" {
                    Image("paid")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .rotationEffect(Angle(degrees: -30))
                        .offset(x: -5)
                        .opacity(0.6)
                }
            }
        }
    }
}

struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
    }
}
