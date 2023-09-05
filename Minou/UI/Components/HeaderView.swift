//
//  HeaderView.swift
//  Minou
//
//  Created by Cédric CALISTI on 06/09/2023.
//

import SwiftUI

struct HeaderView: View {

    @Binding var isSearching: Bool


    var body: some View {
        ZStack{
            HStack {
                Spacer()
                Image("Miaou")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 50)
                Spacer()



            }
            .padding([.horizontal, .bottom])

            HStack {
                Spacer()
                Button(action: {
                    withAnimation(){
                        isSearching.toggle()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                        .padding(.top, 20)
                }
            }
            .padding([.horizontal, .bottom])

        }
    }
}

