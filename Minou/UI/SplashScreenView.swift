//
//  SplashScreenView.swift
//  Minou
//
//  Created by Cédric CALISTI on 06/09/2023.
//

import SwiftUI

struct SplashScreenView: View {

    @EnvironmentObject var catAPIManager: CatAPIManager

    @State var endAnimation = false

    var body: some View {
        Group{
            ZStack {

                BackgroundView()

                if catAPIManager.isLoading && !catAPIManager.breeds.isEmpty {
                    Image("Miaou")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 300, height: 150)
                        .accessibilityLabel("Chargement de l'application")
                } else {
                    ListView()
                }

            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
