//
//  JobsAPI.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

protocol JobsAPI {
    var networkController: NetworkController { get }
    func getJobs(completion: @escaping (Result<Jobs, NetworkError>) -> Void)
    
    func getJobs() async throws -> Jobs
}

class JobsAPIImpl: JobsAPI {
    let networkController: NetworkController

    init(networkController: NetworkController = NetworkControllerImpl()) {
        self.networkController = networkController
    }

    func getJobs() async throws -> Jobs {
        let url = "https://ios-interview.joinhandshake-internal.com/jobs"
        return try await networkController.get(urlString: url)
    }
    
    func getJobs(completion: @escaping (Result<Jobs, NetworkError>) -> Void) {
        let url = "https://ios-interview.joinhandshake-internal.com/jobs"
        networkController.get(urlString: url, completion: completion)
    }
}
