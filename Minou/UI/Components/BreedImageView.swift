//
//  BreedImageView.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI

struct BreedImageView: View {
    @EnvironmentObject var catAPIManager: CatAPIManager
    @EnvironmentObject var cacheImages: CacheImages

    let breedId: String
    let imageId: String?

    var cachedImage: UIImage? {
        if let imageId = imageId,
           let pathCacheImage = cacheImages.imageUrlIfExists(name: imageId),
           let uiImage = UIImage(contentsOfFile: pathCacheImage.path) {
            return uiImage
        }
        return nil
    }

    var placeholderImage: some View {
        Image(systemName: "photo")
            .frame(width: 25, height: 25)
            .foregroundColor(.white)
    }

    var body: some View {

        Group {
            if let cached = cachedImage {
                Image(uiImage: cached)
                    .resizable()
            } else {
                if let imageId = imageId {
                    AsyncImage(url: catAPIManager.getUrlImage(id: imageId)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                        case .failure, .empty:
                            placeholderImage
                        @unknown default:
                            placeholderImage
                        }
                    }
                } else {
                    placeholderImage
                }
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 1))
        .shadow(radius: 2)
        .onAppear {
            if let imageId = imageId,
               cacheImages.imageUrlIfExists(name: imageId) == nil  {
                // Télécharger l'image et mettre dans le cache
                cacheImages.downloadAndStoreImage(urlString: catAPIManager.getStringUrlImage(id: imageId), name: imageId)
            }
        }
    }

}

