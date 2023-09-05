//
//  BreedImageView.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI

struct BreedImageView: View {
    @EnvironmentObject var catAPIManager: CatAPIManager


    let breedId: String
    let imageId: String?
    let imageData: Data?

    var body: some View {

        Group {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage).resizable()
            } else {
                if let imageId = imageId {
                    AsyncImage(url: catAPIManager.getUrlImage(id: imageId)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                        case .failure, .empty:
                            Image(systemName: "photo")
                                .resizable()
                        @unknown default:
                            Image(systemName: "photo")
                                .resizable()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                }
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 1))
        .shadow(radius: 2)
        .onAppear {
            if imageData == nil && imageId != nil {
                // Télécharger l'image et mettre à jour imageData dans CoreData
                catAPIManager.downloadAndStoreImage(breedId: breedId, imageId: imageId!)
            }
        }
    }

}

