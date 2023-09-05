//
//  Persistence.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import CoreData
import OSLog

class CoreDataStorage {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Minou")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }

        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext

    }

    // Récuperation de la liste des races de chat
    func fetchBreedsList() -> [CatsBreed]{
        let listResultBreeds: [CatsBreed]
        let fetchRequest: NSFetchRequest<CDbreeds> = CDbreeds.fetchRequest()

        if let rawBreedsList = try? context.fetch(fetchRequest) {
            listResultBreeds = rawBreedsList.compactMap({ (rawBreeds: CDbreeds) ->
                CatsBreed? in
                CatsBreed(fromCoreDataObject: rawBreeds)

            })

        } else {
            Logger.coreData.error("Erreur récuperations données Coredata (fetchBreedsList)")
            listResultBreeds = []
        }

        return listResultBreeds

    }

    // Ajout des races dans CoreData
    func addNewBreedInCoreData(breeds: [CatsBreed]) {
        var updatedBreedsCount = 0
        var addedBreedsCount = 0


        for breed in breeds {

            // on verifie si la race existe via son ID
            if let existingBreed = fetchCDbreeds(withId: breed.id) {
                updateCDbreedsProperties(cdbreeds: existingBreed, breed: breed)

                updatedBreedsCount += 1
            } else {
                // n'existe pas, donc on l'ajoute
                let breedList = CDbreeds(context: context)
                updateCDbreedsProperties(cdbreeds: breedList, breed: breed)

                addedBreedsCount += 1
            }
        }
        // On sauvegarde une fois tous les changements effectués (plus performant)
        saveData()

        Logger.coreData.info("\(addedBreedsCount) races ajoutée(s)")
        Logger.coreData.info("\(updatedBreedsCount) races mise(s) à jour")
    }

    func storeImageDataToCoreData(breedId: String, imageData: Data) {
        if let existingBreed = fetchCDbreeds(withId: breedId) {
            existingBreed.imageData = imageData
            saveData()
        }
    }


    // MARK: - Private

    private func updateCDbreedsProperties(cdbreeds: CDbreeds, breed: CatsBreed) {
        cdbreeds.id = breed.id
        cdbreeds.name = breed.name
        cdbreeds.weightImperial = breed.weight.imperial
        cdbreeds.weightMetric = breed.weight.metric
        cdbreeds.cfaURL = breed.cfaURL
        cdbreeds.vetstreetURL = breed.vetstreetURL
        cdbreeds.vcahospitalsURL = breed.vcahospitalsURL
        cdbreeds.temperament = breed.temperament
        cdbreeds.origin = breed.origin
        cdbreeds.countryCodes = breed.countryCodes
        cdbreeds.countryCode = breed.countryCode
        cdbreeds.descriptionBreed = breed.description
        cdbreeds.lifeSpan = breed.lifeSpan
        cdbreeds.indoor = Int16(breed.indoor)
        cdbreeds.lap = Int16(breed.lap ?? 0) // Conversion en Int16
        cdbreeds.altNames = breed.altNames
        cdbreeds.adaptability = Int16(breed.adaptability)
        cdbreeds.affectionLevel = Int16(breed.affectionLevel)
        cdbreeds.childFriendly = Int16(breed.childFriendly)
        cdbreeds.dogFriendly = Int16(breed.dogFriendly)
        cdbreeds.energyLevel = Int16(breed.energyLevel)
        cdbreeds.grooming = Int16(breed.grooming)
        cdbreeds.healthIssues = Int16(breed.healthIssues)
        cdbreeds.intelligence = Int16(breed.intelligence)
        cdbreeds.sheddingLevel = Int16(breed.sheddingLevel)
        cdbreeds.socialNeeds = Int16(breed.socialNeeds)
        cdbreeds.strangerFriendly = Int16(breed.strangerFriendly)
        cdbreeds.vocalisation = Int16(breed.vocalisation)
        cdbreeds.experimental = Int16(breed.experimental)
        cdbreeds.hairless = Int16(breed.hairless)
        cdbreeds.natural = Int16(breed.natural)
        cdbreeds.rare = Int16(breed.rare)
        cdbreeds.rex = Int16(breed.rex)
        cdbreeds.suppressedTail = Int16(breed.suppressedTail)
        cdbreeds.shortLegs = Int16(breed.shortLegs)
        cdbreeds.wikipediaURL = breed.wikipediaURL
        cdbreeds.hypoallergenic = Int16(breed.hypoallergenic)
        cdbreeds.referenceImageID = breed.referenceImageID
        cdbreeds.catFriendly = Int16(breed.catFriendly ?? 0)
        cdbreeds.bidability = Int16(breed.bidability ?? 0)
    }


    private func fetchCDbreeds(withId breedId: String) -> CDbreeds? {

        let fetchRequest: NSFetchRequest<CDbreeds> = CDbreeds.fetchRequest()

        let predicateId = NSPredicate(format: "id == %@", breedId)
        fetchRequest.predicate = predicateId

        fetchRequest.fetchLimit = 1 // on en veut qu'un au cas où (peu probable) qui il y ait plusieurs races avec le même id

        do {
            let fetchResult = try context.fetch(fetchRequest)
            return fetchResult.first
        } catch {
            Logger.coreData.error("Erreur lors de l'exécution de la requête fetchCDbreeds : \(error)")
            return nil
        }

    }

    private func saveData() {

        if context.hasChanges {
            do {
                try context.save()
                Logger.coreData.info("Données sauvegardées dans CoreData")
            } catch {
                Logger.coreData.error("Erreur pendant la sauvegarde CoreData : \(error.localizedDescription)")

                // Afficher plus de détails sur l'erreur
                let nserror = error as NSError
                Logger.coreData.error("Erreur \(nserror), \(nserror.userInfo)")

            }
        }
    }

}





//
extension CatsBreed {
    init?(fromCoreDataObject coreDataObject: CDbreeds) {

        self.id = coreDataObject.id ?? "0"
        self.name = coreDataObject.name ?? ""
        self.cfaURL = coreDataObject.cfaURL
        self.vetstreetURL = coreDataObject.vetstreetURL
        self.vcahospitalsURL = coreDataObject.vcahospitalsURL
        self.temperament = coreDataObject.temperament ?? ""
        self.origin = coreDataObject.origin ?? ""
        self.countryCodes = coreDataObject.countryCodes ?? ""
        self.countryCode = coreDataObject.countryCode ?? ""
        self.description = coreDataObject.descriptionBreed ?? ""
        self.lifeSpan = coreDataObject.lifeSpan ?? ""

        // Initialisation des Int
        self.indoor = Int(coreDataObject.indoor)
        self.adaptability = Int(coreDataObject.adaptability)
        self.affectionLevel = Int(coreDataObject.affectionLevel)
        self.childFriendly = Int(coreDataObject.childFriendly)
        self.dogFriendly = Int(coreDataObject.dogFriendly)
        self.energyLevel = Int(coreDataObject.energyLevel)
        self.grooming = Int(coreDataObject.grooming)
        self.healthIssues = Int(coreDataObject.healthIssues)
        self.intelligence = Int(coreDataObject.intelligence)
        self.sheddingLevel = Int(coreDataObject.sheddingLevel)
        self.socialNeeds = Int(coreDataObject.socialNeeds)
        self.strangerFriendly = Int(coreDataObject.strangerFriendly)
        self.vocalisation = Int(coreDataObject.vocalisation)
        self.experimental = Int(coreDataObject.experimental)
        self.hairless = Int(coreDataObject.hairless)
        self.natural = Int(coreDataObject.natural)
        self.rare = Int(coreDataObject.rare)
        self.rex = Int(coreDataObject.rex)
        self.suppressedTail = Int(coreDataObject.suppressedTail)
        self.shortLegs = Int(coreDataObject.shortLegs)
        self.hypoallergenic = Int(coreDataObject.hypoallergenic)
        self.catFriendly = Int(coreDataObject.catFriendly)
        self.bidability = Int(coreDataObject.bidability)

        // Initialisation String?
        self.cfaURL = coreDataObject.cfaURL ?? ""
        self.vetstreetURL = coreDataObject.vetstreetURL ?? ""
        self.vcahospitalsURL = coreDataObject.vcahospitalsURL ?? ""
        self.altNames = coreDataObject.altNames
        self.wikipediaURL = coreDataObject.wikipediaURL
        self.referenceImageID = coreDataObject.referenceImageID

        
        self.weight = Weight(
            imperial: coreDataObject.weightImperial!,
            metric: coreDataObject.weightMetric!
        )

        // Initialisation des Int?
        self.lap = Int(coreDataObject.lap)

        self.imageData = coreDataObject.imageData
    }
}
