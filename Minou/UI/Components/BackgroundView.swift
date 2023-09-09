//
//  BackgroundView.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI

struct BackgroundView: View {

    var body: some View {

        LinearGradient(gradient: Gradient(colors: [Color(red: 255.0/255.0, green: 165.0/255.0, blue: 0.0/255.0), Color.blue]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

    }
}
