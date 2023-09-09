//
//  ContentView.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var catAPIManager: CatAPIManager
    @State private var isSearching: Bool = false
    @State private var searchText = ""
    @State private var selectedBreed: CatsBreed?

    var body: some View {
        
        NavigationView {
            ZStack{
                BackgroundView()
                
                VStack{

                    HeaderView(isSearching: $isSearching)
                    
                    if isSearching {
                        SearchBarView(text: $searchText)
                    }

                    List {
                        ForEach(catAPIManager.breeds) { breed in
                            //NavigationLink {

                            // Si recherche désactivée on affiche toute la liste OU cherche par nom
                            if searchText.isEmpty || (breed.name.lowercased().contains(searchText.lowercased())) {
                                Button(action: {
                                    selectedBreed = breed
                                }) {
                                    HStack{
                                        BreedImageView(breedId: breed.id, imageId: breed.referenceImageID)

                                        Text(breed.name)
                                            .foregroundColor(.white)
                                            .font(.title3)

                                        Spacer()

                                    }
                                }

                            }

                        }
                        .padding(.horizontal, 10)
                        .frame(height: 80)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                        .background(BlurView(style: .light))
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        
                    }
                    .listStyle(.plain)
                    .ignoresSafeArea()
                    .sheet(item: $selectedBreed) { breed in
                        BreedDetailView(breed: breed)

                    }

                }
                .edgesIgnoringSafeArea([.horizontal,.bottom] )

            }
        }
        .accentColor(.white)

    }


}
