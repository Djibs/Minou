//
//  LinksBreedsDetailView.swift
//  Minou
//
//  Created by Cédric CALISTI on 09/09/2023.
//

import SwiftUI

struct LinksBreedsDetailView: View {
    
    let breed: CatsBreed
    
    var body: some View {


        VStack{
            Spacer()
            Spacer()
            HStack{
                Spacer()
                if let wikipediaLink = breed.wikipediaURL {
                    Button(action: {
                        // Ouvrir le lien dans Safari
                        if let url = URL(string: wikipediaLink) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "link")
                            Text("Wikipedia")
                        }
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(5)
                    }
                }
            }
        }
        .padding(.bottom, 17)
        .padding(.trailing, 17)

    }
}
