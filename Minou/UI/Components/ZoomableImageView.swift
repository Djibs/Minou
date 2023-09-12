//
//  ZoomableImageView.swift
//  Minou
//
//  Created by Cédric CALISTI on 12/09/2023.
//

import OSLog
import SwiftUI

struct ZoomableImageView: UIViewRepresentable {

    @EnvironmentObject var cacheImages: CacheImages
    let imageId: String
    @Binding var scale: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 4.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        // Configuration de imageView
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        // Contraintes AutoLayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

        context.coordinator.imageView = imageView

        // Chargement de l'image depuis le cache
        if let pathCacheImage = cacheImages.imageUrlIfExists(name: imageId),
           let image = UIImage(contentsOfFile: pathCacheImage.path) {
                        imageView.image = image
                        let screenSize = UIScreen.main.bounds.size
                        let screenWidth = screenSize.width
                        let screenHeight = screenSize.height
                        let maxHeight: CGFloat = 250

                        let newScale: CGFloat = .minimum(.maximum(scale, 1), 4)

                        let imageSize = image.size
                        let originalScale = imageSize.width / imageSize.height >= screenWidth / screenHeight ?
                        screenWidth / imageSize.width :
                        screenHeight / imageSize.height

                        let imageWidth = (imageSize.width * originalScale) * newScale
                        let imageHeight = (imageSize.height * originalScale) * newScale

                        let widthRatio = screenWidth / imageWidth
                        let heightRatio = screenHeight / imageHeight

                        let maxRatio = min(widthRatio, heightRatio, maxHeight / imageHeight)
                        scrollView.minimumZoomScale = maxRatio
                        scrollView.zoomScale = maxRatio

                        context.coordinator.updateContentInset(scrollView: scrollView)
                } else {
                    Logger.viewCycle.error("Erreur de chargement de l'image pour le zoom")
                }

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.updateImageViewSize(scrollView: uiView)

    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var view: ZoomableImageView
        var imageView: UIImageView?  // Stocker une référence directe à imageView

        init(_ view: ZoomableImageView) {
            self.view = view
        }

        // Vue à zoomer
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            imageView
        }
        // Mise à jour de l'inset lors du zoom
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            updateContentInset(scrollView: scrollView)
        }

        func updateContentInset(scrollView: UIScrollView) {
            if let imageView = imageView {
                let offsetX = max((scrollView.bounds.width - imageView.frame.width) * 0.5, 0.0)
                let offsetY = max((scrollView.bounds.height - imageView.frame.height) * 0.5, 0.0)

                scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
            }
        }
        // Animation de fin de zoom
        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            if let imageView = imageView {
                let offsetX = max((scrollView.bounds.width - imageView.frame.width) * 0.5, 0.0)
                let offsetY = max((scrollView.bounds.height - imageView.frame.height) * 0.5, 0.0)

                scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)


                UIView.animate(withDuration: 0.25) {
                    scrollView.layoutIfNeeded()
                }
            }
        }
        // Mise à jour de la taille de imageView
        func updateImageViewSize(scrollView: UIScrollView) {
            if let imageView = self.imageView {
                imageView.frame.size = scrollView.frame.size
            }
        }
    }
}
