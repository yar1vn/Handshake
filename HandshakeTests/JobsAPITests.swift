//
//  JobsAPITests.swift
//  JobsAPITests
//
//  Created by Yariv on 3/19/24.
//

import XCTest
@testable import Handshake

final class JobsAPITests: XCTestCase {
    let networkController = MockNetworkController(json: "jobs.json")
    let networkController_Malformed = MockNetworkController(json: "jobs_malformed.json")
    
    func testAPI() async throws {
        let api = JobsAPIImpl(networkController: networkController)
        let jobs = try await api.getJobs()
        
        XCTAssertEqual(jobs.count, 10)
        XCTAssertEqual(jobs.first?.id, 1)
        XCTAssertEqual(jobs.first?.employer.name, "Handshake")
    }
    
    func testMalformedAPI() async throws {
        let api = JobsAPIImpl(networkController: networkController_Malformed)
        
        do {
            _ = try await api.getJobs()
        } catch(NetworkError.JSONError) {
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
}
