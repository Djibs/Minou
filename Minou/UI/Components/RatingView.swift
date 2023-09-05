//
//  RatingView.swift
//  Minou
//
//  Created by Cédric CALISTI on 06/09/2023.
//

import SwiftUI

struct RatingView: View {
    let title: String
    let rating: Int?

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            HStack {
                ForEach(0..<(rating ?? 0), id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                }
                ForEach((rating ?? 0)..<5, id: \.self) { _ in
                    Image(systemName: "star")
                        .foregroundColor(Color.white)
                }
            }
        }


    }
}
