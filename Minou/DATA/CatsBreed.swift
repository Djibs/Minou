//
//  CatsBreed.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import Foundation


// MARK: - CatsBreed
struct CatsBreed: Identifiable, Codable, Comparable {
    let weight: Weight
    let id, name: String
    var cfaURL: String?
    var vetstreetURL: String?
    var vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String
    let description, lifeSpan: String
    let indoor: Int
    var lap: Int?
    let altNames: String?
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int
    let energyLevel, grooming, healthIssues, intelligence: Int
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int
    let experimental, hairless, natural, rare: Int
    let rex, suppressedTail, shortLegs: Int
    let wikipediaURL: String?
    let hypoallergenic: Int
    let referenceImageID: String?
    let catFriendly, bidability: Int?
    var imageData: Data?

    enum CodingKeys: String, CodingKey {
        case weight, id, name
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case description
        case lifeSpan = "life_span"
        case indoor, lap
        case altNames = "alt_names"
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
        case referenceImageID = "reference_image_id"
        case catFriendly = "cat_friendly"
        case bidability
        case imageData
    }

    public static func < (lhs: CatsBreed, rhs: CatsBreed) -> Bool {
        return lhs.name < rhs.name
    }

    public static func == (lhs: CatsBreed, rhs: CatsBreed) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Weight
struct Weight: Codable {
    let imperial, metric: String
}
