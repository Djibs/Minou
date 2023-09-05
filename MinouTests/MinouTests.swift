//
//  MinouTests.swift
//  MinouTests
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import XCTest
@testable import Minou


class CatAPIManagerTests: XCTestCase {

    var sut: CatAPIManager!
    var mockNetworkMonitor: NetworkMonitor!

    override func setUp() {
        super.setUp()
        mockNetworkMonitor = NetworkMonitor()
        sut = CatAPIManager(networkMonitor: mockNetworkMonitor)
    }

    override func tearDown() {
        sut = nil
        mockNetworkMonitor = nil
        super.tearDown()
    }

    func testFetchBreedsNetworkNotConnected() {
        // Arrange
        mockNetworkMonitor.isConnected = false

        // Act
        sut.fetchBreeds()

        // Assert
        XCTAssertFalse(sut.breeds.isEmpty)
    }

    func testFetchBreedsNetworkConnected() {
        // Déclaration de l'attente asynchrone
        let expectation = self.expectation(description: "Réponse asynchrone attendue")

        // Arrange
        mockNetworkMonitor.isConnected = true

        // Act
        sut.fetchBreeds()

        // Assertion asynchrone
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             // Assert
             XCTAssertFalse(self.sut.breeds.isEmpty, "Breeds ne doit pas être vide après l'appel à la fonction fetchBreeds")
             XCTAssertFalse(self.sut.isLoading, "isLoading devrait devenir false après l'appel a la fonction fetchBreeds")

             // Valider que l'attente est terminée
             DispatchQueue.main.async {
                 expectation.fulfill()
             }
         }

         // Attendre que l'attente asynchrone se termine
         wait(for: [expectation], timeout: 3.0)
    }


}
