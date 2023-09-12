//
//  ButtonCloseSheetView.swift
//  Minou
//
//  Created by Cédric CALISTI on 12/09/2023.
//

import SwiftUI

struct ButtonCloseSheetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray)
                .frame(width: 50, height: 5)
                .padding(5)
                .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .accessibilityLabel("Fermer")
            
            Spacer()
        }
    }
}
