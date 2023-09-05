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


    @ObservedObject var networkMonitor: NetworkMonitor

    let baseURL = "https://api.thecatapi.com/v1"
    let baseURLImage = "https://cdn2.thecatapi.com/images"


    let storage = CoreDataStorage()

    @Published var breeds: [CatsBreed] = []
    @Published var isLoading = true

    init(networkMonitor: NetworkMonitor = NetworkMonitor()) {
        self.networkMonitor = networkMonitor

        fetchBreeds()
    }


    func fetchBreeds() {

        // Vérifier la connexion réseau
        guard networkMonitor.isConnected else {
            // Récupérer les données depuis Coredat si pas de connexion
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

    func getUrlImage(id: String) -> URL{
        let url = URL(string: "\(baseURLImage)/\(id).jpg")!
        return url
    }

    func downloadAndStoreImage(breedId: String, imageId: String) {
        //Si la fonction est appelée, c'est que l'image n'est pas en cache dans coredata

        // Vérifier la connexion réseau
        guard networkMonitor.isConnected else { return}

        let imageUrl = getUrlImage(id: imageId)
        URLSession.shared.dataTask(with: imageUrl) { (data, _, _) in
            if let data = data {
                // Stocker l'image dans CoreData
                self.storage.storeImageDataToCoreData(breedId: breedId, imageData: data)
            }
        }.resume()
    }



    // Mark: - Private

    private func addNewBreed(breedsList: [CatsBreed]) {
        storage.addNewBreedInCoreData(breeds: breedsList)
    }
}
