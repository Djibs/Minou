//
//  headerImageBreedDetailView.swift
//  Minou
//
//  Created by Cédric CALISTI on 12/09/2023.
//

import SwiftUI

struct headerImageBreedDetailView: View {
    @EnvironmentObject var cacheImages: CacheImages

    let breedId: String?
    let geometryWidth: CGFloat
    let geometryHeight: CGFloat

    var cachedImage: UIImage? {

        if let imageId = breedId, let pathCacheImage = cacheImages.imageUrlIfExists(name: imageId),
           let uiImage = UIImage(contentsOfFile: pathCacheImage.path) {
            return uiImage
        }
        return nil
    }
    var body: some View {
        if let cached = cachedImage {
            Image(uiImage: cached)
                .resizable()
                .scaledToFill()
                .frame(width: geometryWidth, height: geometryHeight * 0.4)
                .clipped()
                .edgesIgnoringSafeArea([.vertical])
        } else {
            Text("Image non disponible")
                .frame(width: geometryWidth, height: geometryHeight * 0.4)
                .background(Color.gray)
                .edgesIgnoringSafeArea([.top])
        }
    }
}
