//
//  CustomDialog.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 25/01/22.
//
import SwiftUI

struct CustomDialog<ProgressDialogContent: View>: ViewModifier {
    @Binding var isShowing: Bool // set this to show/hide the dialog
    let progressContent: ProgressDialogContent

    init(
        isShowing: Binding<Bool>,
        @ViewBuilder progressContent: () -> ProgressDialogContent
    ) {
        _isShowing = isShowing
        self.progressContent = progressContent()
    }

    func body(content: Content) -> some View {
        // wrap the view being modified in a ZStack and render dialog on top of it
        ZStack {
            content
            if isShowing {
                // the semi-transparent overlay
                Rectangle().foregroundColor(Color.black.opacity(0.3)).ignoresSafeArea(.container, edges: .vertical)
                // the dialog content is in a ZStack to pad it from the edges
                // of the screen
                ZStack {
                    progressContent.padding(40)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.Size.DEFAULT_CORNER_RADIUS)
                                .foregroundColor(.secondarySystemBackground))
                }
            }
        }
    }
}

extension View {
    func customProgressDialog<ProgressDialogContent: View>(
        isShowing: Binding<Bool>,
        @ViewBuilder progressContent: @escaping () -> ProgressDialogContent
    ) -> some View {
        self.modifier(CustomDialog(isShowing: isShowing, progressContent: progressContent))
    }
}
