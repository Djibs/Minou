//
//  RatingView.swift
//  Minou
//
//  Created by Cédric CALISTI on 06/09/2023.
//

import SwiftUI

struct RatingView: View {
    let title: String?
    let rating: Double?

    var fullStars: Int {
        Int(rating ?? 0)
    }

    var hasHalfStar: Bool {
        (rating ?? 0).truncatingRemainder(dividingBy: 1) >= 0.5
    }

    var body: some View {
        HStack {
            if let title = title {
                Text(title)
                    .font(.subheadline)
            }
            Spacer()

            HStack {
                // Étoiles complètes
                ForEach(0..<fullStars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                }

                // Demi-étoile, si nécessaire
                if hasHalfStar {
                    Image(systemName: "star.lefthalf.fill")
                        .foregroundColor(Color.yellow)
                }

                // Étoiles vides
                ForEach((fullStars + (hasHalfStar ? 1 : 0))..<5, id: \.self) { _ in
                    Image(systemName: "star")
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}

