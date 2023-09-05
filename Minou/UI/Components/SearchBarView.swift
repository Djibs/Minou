//
//  SearchBarView.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI


struct SearchBarView: View {

    @Binding var text: String

    @State private var isEditing = false

    var body: some View {

        HStack {

            TextField("Recherche", text: $text)
                .foregroundColor(.white)
                .padding(7)
                .padding(.horizontal, 23)
                .foregroundColor(.white)
                .background(BlurView(style: .light))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }

        }
    }
}
