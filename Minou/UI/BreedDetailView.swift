//
//  BreedDetailView.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI

struct BreedDetailView: View {
    
    @EnvironmentObject var catAPIManager: CatAPIManager

    @State private var imageIds: [String] = []
    @State var idImageZoom: String?
    @State var openZoomView: Bool = false

    let breed: CatsBreed

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                
                BackgroundView()
                
                VStack {
                    ZStack {

                        headerImageBreedDetailView(breedId: breed.referenceImageID, geometryWidth: geometry.size.width, geometryHeight: geometry.size.height)

                        LinksBreedsDetailView(breed: breed)

                        ButtonCloseSheetView()

                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(breed.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top)
                            
                            Text("Origine : \(breed.origin)")
                                .font(.subheadline)
                            
                            Text("Tempérament : \(breed.temperament)")
                                .font(.subheadline)
                            
                            Text("Durée de vie : \(breed.lifeSpan) ans")
                                .font(.subheadline)
                            
                            Text("Poids moyen : \(breed.weight.metric) kg")
                                .font(.subheadline)
                            
                            Text("Description")
                                .font(.headline)
                            
                            Text(breed.description)
                                .font(.body)
                                .padding(.bottom)

                            HStack {
                                Text("Note moyenne: ")
                                Spacer()
                                calculateAverageRating(for: breed)
                            }
                            .font(.title2)
                            .fontWeight(.bold)


                            Group {
                                RatingView(title: "Adaptabilité", rating: Double(breed.adaptability))
                                RatingView(title: "Niveau d'affection", rating: Double(breed.affectionLevel))
                                RatingView(title: "Convivialité envers les enfants", rating: Double(breed.childFriendly))
                                RatingView(title: "Convivialité envers les chiens", rating: Double(breed.dogFriendly))
                                RatingView(title: "Niveau d'énergie", rating: Double(breed.energyLevel))

                                RatingView(title: "Toilettage", rating: Double(breed.grooming))
                                RatingView(title: "Problèmes de santé", rating: Double(breed.healthIssues))
                                RatingView(title: "Intelligence", rating: Double(breed.intelligence))
                                RatingView(title: "Niveau de perte de poils", rating: Double(breed.sheddingLevel))
                                RatingView(title: "Besoins sociaux", rating: Double(breed.socialNeeds))


                            }
                            Group{
                                if !imageIds.isEmpty {
                                    ScrollImagesView(idImageZoom: $idImageZoom, openZoomView: $openZoomView, imagesIds: imageIds)
                                }
                            }
                            .padding(.vertical)

                        }
                        .padding(.horizontal)
                        
                    }
                    .padding(.vertical, -8)
                }
                .foregroundColor(.white)

                if openZoomView, let id = idImageZoom {
                    ZoomView(imageId: id, openZoomView: $openZoomView)
                }
                
            }
        }
        .onAppear{
            if breed.imagesIds == nil {
                catAPIManager.fetchImagesIDs(breed: breed) { fetchedIDs in
                    if let ids = fetchedIDs {
                        self.imageIds = ids
                    }
                }
            }

        }
    }

    func calculateAverageRating(for breed: CatsBreed) -> some View {
        let ratings = [
            breed.adaptability,
            breed.affectionLevel,
            breed.childFriendly,
            breed.dogFriendly,
            breed.energyLevel,
            breed.grooming,
            breed.healthIssues,
            breed.intelligence,
            breed.sheddingLevel,
            breed.socialNeeds
        ]

        guard !ratings.isEmpty else {
            return RatingView(title: "", rating: nil)
        }

        let sum = ratings.reduce(0, +)
        let average = Double(sum) / Double(ratings.count)
        let roundedAverage = (average * 2).rounded() / 2 // Arrondis à la valeur .0 ou .5 la plus proche

        return RatingView(title: "", rating: roundedAverage)
    }

}
