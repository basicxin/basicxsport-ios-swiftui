//
//  InfiniteList.swift
//  BasicxSport
//
//  Created by Somesh K on 03/03/22.
//

import SwiftUI

struct InfiniteList<Data, Content>: View
    where Data: RandomAccessCollection, Data.Element: Hashable, Content: View
{
    @Binding var data: Data
    @Binding var isLoading: Bool
    let loadMore: () -> Void
    let content: (Data.Element) -> Content

    init(data: Binding<Data>,
         isLoading: Binding<Bool>,
         loadMore: @escaping () -> Void,
         @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        _data = data
        _isLoading = isLoading
        self.loadMore = loadMore
        self.content = content
    }

    var body: some View {
        List {
            ForEach(data, id: \.self) { item in
                content(item)
                    .onAppear {
                        if item == data.last {
                            loadMore()
                        }
                    }
            }
            if isLoading {
                ProgressView()
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            }
        }.onAppear(perform: loadMore)
    }
}
