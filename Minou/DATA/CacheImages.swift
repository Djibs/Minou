//
//  CacheImages.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import Foundation
import OSLog
import SwiftUI


final class CacheImages: ObservableObject  {

    var networkMonitor: NetworkMonitor

    let imagesCacheDirectoryName = "ImagesCache"

    init(networkMonitor: NetworkMonitor) {
        self.networkMonitor = networkMonitor
        
        // S'assurer que le dossier de cache image existe
        if let _ = ensureCacheDirectoryExists(directoryName: self.imagesCacheDirectoryName) {
            Logger.cacheImages.error("Le dossier \(self.imagesCacheDirectoryName) existe.")
        } else {
            Logger.cacheImages.error("Le dossie \(self.imagesCacheDirectoryName) n'existe pas et impossible de le créer.")
        }
    }

    func downloadAndStoreImage(urlString: String, name: String) {
        // Vérifier la connexion réseau
        guard networkMonitor.isConnected else { return }

        if let imageUrl = getUrlImage(urlString: urlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    Logger.catAPIManager.error("Réponse invalide")
                    return
                }

                if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300, let data = data {
                    // Sauvegarder l'image dans le système de fichiers
                    self.saveDocumentToFileSystem(data: data, name: name)
                } else if httpResponse.statusCode == 400 || httpResponse.statusCode == 403 {
                    // Gérer les erreurs spécifiques
                    Logger.catAPIManager.warning("Échec du téléchargement, code \(httpResponse.statusCode) , on teste dans un autre format.")

                    // Réessayer avec le format PNG
                    if urlString.hasSuffix(".jpg") {
                        let newUrlString = urlString.replacingOccurrences(of: ".jpg", with: ".png")
                        self.downloadAndStoreImage(urlString: newUrlString, name: name)
                    } else {
                        Logger.catAPIManager.warning("Échec du téléchargement, code \(httpResponse.statusCode),  ce n'est pas non plus le format png")
                    }
                } else {
                    Logger.catAPIManager.error("Problème de réponse serveur ou pas de données")
                }
            }.resume()
        }
    }



    // Sauvgegarder un fichier dans le système de fichiers de l'appareil.
    func saveDocumentToFileSystem(data: Data, name: String) {
        // Conversion en JPEG si pas au bon format
        guard let imageData = convertToJPEGIfPossible(data: data) else {
            Logger.cacheImages.error("Erreur lors de la conversion de l'image.")
            return
        }

        // Création de l'URL complète pour le fichier, y compris le nom du fichier
        guard let fileURL = fileURL(name: name) else {
            Logger.cacheImages.error("Impossible de créer l'URL du fichier.")
            return
        }

        do {
            // Écriture des données du fichier (image uu html) dans le fichier à l'emplacement spécifié par fileURL
            try imageData.write(to: fileURL)

        } catch let error as FileError {
            switch error {
            case .fileNotFound:
                Logger.cacheImages.error("Fichier non trouvé.")
                return

            case .invalidPath:
                Logger.cacheImages.error("Chemin non valide.")
                return

            case .unableToWrite:
                Logger.cacheImages.error("Écriture impossible.")
                return
            }
        } catch {
            Logger.cacheImages.error("Erreur non spécifiée: \(error)")
            return
        }
    }


    func imageUrlIfExists(name: String) -> URL? {

        guard let fileURL = fileURL(name: name) else {
            return nil
        }

        // Vérifiez si le fichier existe
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        } else {
            return nil
        }
    }

    func fileURL(name: String) -> URL? {
        guard let imageCacheDirectory = ensureCacheDirectoryExists(directoryName: imagesCacheDirectoryName) else {
            Logger.cacheImages.error("Impossible de créer ou trouver le dossier de cache.")
            return nil
        }

        return imageCacheDirectory.appendingPathComponent("\(name).jpg")

    }


    // MARK: - Private

    private func getUrlImage(urlString: String) -> URL? {
        if let url = URL(string: urlString) {
            return url
        }
        return nil
    }

    // Vérifie et crée le dossier de cache si nécessaire
    private func ensureCacheDirectoryExists(directoryName: String) -> URL? {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            Logger.cacheImages.error("Erreur: Impossible d'obtenir le chemin du dossier de cache.")
            return nil
        }

        let specificCacheDirectory = cacheDirectory.appendingPathComponent(directoryName)

        if !FileManager.default.fileExists(atPath: specificCacheDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: specificCacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                Logger.cacheImages.error("Erreur de création du dossier de cache: \(error)")
                return nil
            }
        }

        return specificCacheDirectory
    }

    private func convertToJPEGIfPossible(data: Data) -> Data? {
        if let format = imageFormat(for: data), format == "png" {
            guard let image = UIImage(data: data) else {
                Logger.cacheImages.error("Impossible de convertir les données en UIImage.")
                return nil
            }
            guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
                Logger.cacheImages.error("Échec de la conversion en JPEG.")
                return nil
            }
            return jpegData
        }
        return data
    }

    private func imageFormat(for data: Data) -> String? {
        var c: UInt8 = 0
        data.copyBytes(to: &c, count: 1)

        switch c {
        case 0xFF:
            return "jpg"
        case 0x89:
            return "png"
        default:
            return nil
        }
    }
}


enum FileError: Error {
    case fileNotFound
    case invalidPath
    case unableToWrite
}
