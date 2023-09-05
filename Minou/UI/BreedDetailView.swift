//
//  BreedDetailView.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI

struct BreedDetailView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let breed: CatsBreed

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                
                BackgroundView()
                
                VStack {
                        if let _ = breed.referenceImageID,
                           let imageData = breed.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                                .clipped()
                                .edgesIgnoringSafeArea([.vertical])
                        } else {
                            Text("Image non disponible")
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                                .background(Color.gray)
                                .edgesIgnoringSafeArea([.top])
                        }

                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(breed.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
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
                            
                            Group {
                                RatingView(title: "Adaptabilité", rating: breed.adaptability)
                                RatingView(title: "Niveau d'affection", rating: breed.affectionLevel)
                                RatingView(title: "Convivialité envers les enfants", rating: breed.childFriendly)
                                RatingView(title: "Convivialité envers les chiens", rating: breed.dogFriendly)
                                RatingView(title: "Niveau d'énergie", rating: breed.energyLevel)
                            }
                            
                            Group {
                                RatingView(title: "Toilettage", rating: breed.grooming)
                                RatingView(title: "Problèmes de santé", rating: breed.healthIssues)
                                RatingView(title: "Intelligence", rating: breed.intelligence)
                                RatingView(title: "Niveau de perte de poils", rating: breed.sheddingLevel)
                                RatingView(title: "Besoins sociaux", rating: breed.socialNeeds)
                            }
                            
                            
                        }
                        .padding()
                    }
                }
                .foregroundColor(.white)

            }
        }
    }
}
