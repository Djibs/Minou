//
//  CatAPIManager.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import Foundation
import OSLog
import SwiftUI

final class CatAPIManager: ObservableObject {

    var networkMonitor: NetworkMonitor

    let baseURL = "https://api.thecatapi.com/v1"
    let baseURLImage = "https://cdn2.thecatapi.com/images"

    let storage = CoreDataStorage()

    @Published var breeds: [CatsBreed] = []
    @Published var isLoading = true
    @Published var imagesiDs: [String] = [] {

        willSet {
            print(imagesiDs)
        }
    }

    init(networkMonitor: NetworkMonitor) {
        self.networkMonitor = networkMonitor

        fetchBreeds()
    }


    func fetchBreeds() {

        // Vérifier la connexion réseau
        guard networkMonitor.isConnected else {
            // Récupérer les données depuis Coredata si pas de connexion
            self.breeds = self.storage.fetchBreedsList().sorted()
            return
        }


        guard let apiUrl = URL(string: "\(baseURL)/breeds") else { return  }

        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: apiUrl, timeoutInterval: 30)

        let dataTask = urlSession.dataTask(with: request) { data, response, error in

            guard error == nil else {
                Logger.catAPIManager.error("Erreur réseau: \(error!.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200 && httpResponse.statusCode < 300,
                  let breedsListJsonData = data else {
                Logger.catAPIManager.error("Problème de réponse serveur ou pas de données")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            do {
                let downloadedBreedList = try JSONDecoder().decode([CatsBreed].self, from: breedsListJsonData)// {


                DispatchQueue.main.async {

                    if !downloadedBreedList.isEmpty {

                        self.addNewBreed(breedsList: downloadedBreedList) //ajout dan coredata pour l'utilisation hors lignes

                        self.breeds = self.storage.fetchBreedsList().sorted() // recuperation dans coredata + tri par ordre alaphebtique

                    } else {
                        Logger.catAPIManager.warning("Pas d'elements à traiter dans le tableau")
                    }

                    self.isLoading = false

                }

            } catch let DecodingError.dataCorrupted(context) {
                Logger.catAPIManager.error("\(context.debugDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false

                }
            } catch let DecodingError.keyNotFound(key, context) {
                Logger.catAPIManager.error("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                Logger.catAPIManager.error("codingPath: \(context.codingPath)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } catch let DecodingError.valueNotFound(value, context) {
                Logger.catAPIManager.error("Value '\(value)' not found: \(context.debugDescription)")
                Logger.catAPIManager.error("codingPath: \(context.codingPath)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } catch let DecodingError.typeMismatch(type, context) {
                Logger.catAPIManager.error("Type '\(type)' mismatch: \(context.debugDescription)")
                Logger.catAPIManager.error("codingPath: \(context.codingPath)")
                DispatchQueue.main.async {
                    self.isLoading = false

                }
            } catch {
                Logger.catAPIManager.error("error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false

                }
            }

            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        self.isLoading = true

        dataTask.resume()

        DispatchQueue.main.async {
            self.isLoading = false

        }
    }
    func fetchImagesIDs(breed: CatsBreed, completion: @escaping ([String]?) -> Void) {


        guard networkMonitor.isConnected else {
            // Récupérer les données depuis Coredata si pas de connexion
            completion(getImagesIds(breedId: breed.id))
            return
        }

        guard let url = URL(string: "\(baseURL)/images/search?breed_id=\(breed.id)&limit=10") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                Logger.catAPIManager.error("Erreur réseau: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200 && httpResponse.statusCode < 300,
                  let imagesListJsonData = data else {
                Logger.catAPIManager.error("Problème de réponse serveur pour la recherche d'imagesou pas de données")
                completion(nil)
                return
            }

            do {
                let catImages = try JSONDecoder().decode([SearchImages].self, from: imagesListJsonData)
                var fetchedIDs = catImages.map { $0.id }
                let joinedIDs = fetchedIDs.joined(separator: ",") // on crée un seul string qui sépare les ids par une virgule

                // on stocke dans coredata...
                self.storage.saveImagesIDs(joinedIDs, breed: breed)
                completion(fetchedIDs)
            } catch let DecodingError.dataCorrupted(context) {
                Logger.catAPIManager.error("\(context.debugDescription)")
                completion(nil)

            } catch let DecodingError.keyNotFound(key, context) {
                Logger.catAPIManager.error("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                Logger.catAPIManager.error("codingPath: \(context.codingPath)")
                completion(nil)

            } catch let DecodingError.valueNotFound(value, context) {
                Logger.catAPIManager.error("Value '\(value)' not found: \(context.debugDescription)")
                Logger.catAPIManager.error("codingPath: \(context.codingPath)")
                completion(nil)

            } catch let DecodingError.typeMismatch(type, context) {
                Logger.catAPIManager.error("Type '\(type)' mismatch: \(context.debugDescription)")
                Logger.catAPIManager.error("codingPath: \(context.codingPath)")
                completion(nil)

            } catch {
                Logger.catAPIManager.error("error: \(error)")
                completion(nil)
            }

        }.resume()
    }

    func getImagesIds(breedId: String) -> [String]? {
        if let imagesIdsString = self.storage.fetchImagesIds(breedId: breedId),
           !imagesIdsString.isEmpty {
            let imagesIdsArray = imagesIdsString.split(separator: ",").map(String.init)
            return imagesIdsArray.isEmpty ? nil : imagesIdsArray
        }
        return nil
    }


    func getStringUrlImage(id: String) -> String{
        return baseURLImage + "/" + id + ".jpg"
    }

    func getUrlImage(id: String) -> URL?{
        if let url = URL(string:  getStringUrlImage(id: id)) {
            return url
        }
        return nil
    }

    // MARK: - Private


    private func addNewBreed(breedsList: [CatsBreed]) {
        storage.addNewBreedInCoreData(breeds: breedsList)
    }
}
