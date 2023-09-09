//
//  ScrollImagesView.swift
//  Minou
//
//  Created by Cédric CALISTI on 09/09/2023.
//

import SwiftUI

struct ScrollImagesView: View {

    @EnvironmentObject var cacheImages: CacheImages
    @EnvironmentObject var catAPIManager: CatAPIManager

    let imagesIds: [String]


    var placeholderImage: some View {
        Image(systemName: "photo")
            .foregroundColor(.white)
    }

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false ){
            HStack() {
                ForEach(imagesIds, id: \.self) { imageId in
                    if let cached = cachedImage(imageId: imageId) {
                        Image(uiImage: cached)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .shadow(radius: 2)
                    } else {
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
                        .scaledToFit()
                        .frame(height: 150)
                        .shadow(radius: 2)
                        .onAppear {
                            if cacheImages.imageUrlIfExists(name: imageId) == nil  {
                                // Télécharger l'image et mettre dans le cache
                                cacheImages.downloadAndStoreImage(urlString: catAPIManager.getStringUrlImage(id: imageId), name: imageId)
                            }
                        }
                    }
                }
            }
        }
    }

    func cachedImage(imageId: String)-> UIImage? {
        if let pathCacheImage = cacheImages.imageUrlIfExists(name: imageId),
           let uiImage = UIImage(contentsOfFile: pathCacheImage.path) {
            return uiImage
        }
        return nil
    }
}
