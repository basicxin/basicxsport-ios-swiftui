//
//  OrderHistoryDetailView.swift
//  BasicxSport
//
//  Created by Somesh K on 03/03/22.
//

import SwiftUI

struct OrderHistoryDetailView: View {
    var order: Order
    var body: some View {
        VStack {
            Text("Order #").fontWeight(.light)
            Text(order.invoiceNo).font(.headline)

            HStack {
                VStack {
                    Text("Order Date").fontWeight(.light)
                    Text(Date(milliseconds: Int64(order.dateOfSale)).getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_TIME_FORMAT)).font(.headline)
                }
                Spacer()
                VStack {
                    Text("Payment Status").fontWeight(.light)
                    if order.status != nil {
                        Text(order.status!).foregroundColor(.green).fontWeight(.heavy).font(.title3)
                    }
                }
            }.padding(.top, 10)

            List(order.itemList, id: \.self) { item in

                if item.tournamentCategory != nil {
                    VStack(alignment: .leading) {
                        Text(item.tournamentCategory!.name).fontWeight(.medium)
                        Text(item.tournamentCategory!.productDescription).fontWeight(.light)
                        HStack {
                            Text("Quantity").fontWeight(.light)
                            Text(item.quantity.string)
                        }

                        HStack {
                            Text("Price").fontWeight(.light)
                            Text(Constants.RUPEE + item.amount.string).font(.title3).fontWeight(.semibold)
                        }
                    }
                }

                if item.product != nil {
                    VStack(alignment: .leading) {
                        Text(item.product!.name).fontWeight(.medium)
                        Text(item.product!.productDescription).fontWeight(.light)
                        HStack {
                            Text("Quantity").fontWeight(.light)
                            Text(item.quantity.string)
                        }

                        HStack {
                            Text("Price").fontWeight(.light)
                            Text(Constants.RUPEE + item.amount.string).font(.title3).fontWeight(.semibold)
                        }
                    }
                }

                if item.subscription != nil {
                    VStack(alignment: .leading) {
                        Text(item.subscription!.name).fontWeight(.medium)
                        Text(item.subscription!.productDescription).fontWeight(.light)
                        HStack {
                            Text("Quantity").fontWeight(.light)
                            Text(item.quantity.string)
                        }

                        HStack {
                            Text("Price").fontWeight(.light)
                            Text(Constants.RUPEE + item.amount.string).font(.title3).fontWeight(.semibold)
                        }
                    }
                }
            }
            .padding(.top, 10)
            .listStyle(.plain)

            VStack {
                HStack {
                    Text("Subtotal").font(.subheadline)
                    Spacer()
                    Text(Constants.RUPEE + order.subTotal.string)
                }
                HStack {
                    Text("Discount").font(.subheadline)
                    Spacer()
                    Text(Constants.RUPEE + order.discount.string)
                }
                HStack {
                    Text("Other Charges").font(.subheadline)
                    Spacer()
                    Text(Constants.RUPEE + order.otherCharges.string)
                }
                HStack {
                    Text("Tax").font(.subheadline)
                    Spacer()
                    Text(Constants.RUPEE + order.tax.string)
                }

                Divider()

                HStack {
                    Text("Total Payable Amount").font(.headline)
                    Spacer()
                    Text(Constants.RUPEE + order.totalAmount.string).font(.headline)
                }
            }.fullWidth()
        }
        .padding()
        .fullSize(alignement: .top)
    }
}

struct OrderHistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryDetailView(order: Order(id: 1, invoiceNo: "IN2022-80", totalAmount: 1000.0, status: "PAID", dateOfSale: 2312312312, discount: 100, subTotal: 100, otherCharges: 100.0, tax: 10.0, circle: CircleOrderHistory(id: 0, name: "JAIPUR", logoUrl: "www.google.com"), itemList: [ItemList(id: 1, amount: 100, quantity: 1, product: nil, subscription: ProductOrderHistory(id: 1, name: "Some product", productDescription: "Some description"), tournamentCategory: nil)]))
    }
}
