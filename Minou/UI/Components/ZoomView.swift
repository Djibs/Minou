//
//  ZoomView.swift
//  Minou
//
//  Created by Cédric CALISTI on 12/09/2023.
//

import SwiftUI

struct ZoomView: View {

    let imageId: String
    @Binding var openZoomView: Bool

    @State private var scale: CGFloat = 1

    var body: some View {

        ZStack {

            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(BlurView(style: .systemMaterialDark))
                .onTapGesture {
                    openZoomView = false
                }

            ZoomableImageView(imageId: imageId, scale: $scale)

            Button(action: {
                openZoomView = false
            }, label: {
                VStack {
                    HStack {
                        Image(systemName: "xmark")
                        Spacer()
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    .padding(.bottom, -50)
                    .font(.body)
                    Spacer()
                }
            })
            .accessibilityLabel("Fermer")
        }
        .ignoresSafeArea()

    }
}
