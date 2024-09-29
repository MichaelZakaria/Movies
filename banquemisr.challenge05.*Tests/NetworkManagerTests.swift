//
//  NetworkManagerTests.swift
//  banquemisr.challenge05.*Tests
//
//  Created by Marco on 2024-09-29.
//

import XCTest
@testable import banquemisr_challenge05__

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManagerProtocol!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = mockNetworkManager
    }

    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testFetchMoviesSuccess() {
        let expectation = XCTestExpectation(description: "Fetch movies successfully")
        mockNetworkManager.shouldReturnErrorForMovies = false

        sut.fetchMovies(endPoint: .nowPlaying, type: MoviesResponse.self) { result in
            switch result {
            case .success(let moviesResponse):
                XCTAssertFalse(moviesResponse.results.isEmpty, "Expected movies to be loaded")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchMoviesFailure() {
        let expectation = XCTestExpectation(description: "Fetch movies failed")
        mockNetworkManager.shouldReturnErrorForMovies = true

        sut.fetchMovies(endPoint: .popular, type: MoviesResponse.self) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Expected an error")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMoviePosterSuccess() {
            let expectation = XCTestExpectation(description: "Fetch movie poster successfully")
            mockNetworkManager.shouldReturnErrorForPoster = false
            
            sut.fetchMoviePoster(posterPath: "/path/to/poster") { data in
                XCTAssertFalse(data.isEmpty, "Expected non-empty data for the poster")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }
    
    func testFetchMoviePosterFailure() {
            let expectation = XCTestExpectation(description: "Fetch movie poster failed")
            mockNetworkManager.shouldReturnErrorForPoster = true
            
            sut.fetchMoviePoster(posterPath: "/path/to/poster") { data in
                XCTAssertTrue(data.isEmpty, "Expected no data for the poster on failure")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }
}
