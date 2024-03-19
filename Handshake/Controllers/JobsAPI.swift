//
//  JobsAPI.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

protocol JobsAPI {
    var networkController: NetworkController { get }
    func getJobs(completion: @escaping (Result<Jobs, NetworkError>) -> Void)
}

class JobsAPIImpl: JobsAPI {
    let networkController: NetworkController

    init(networkController: NetworkController = NetworkControllerImpl()) {
        self.networkController = networkController
    }

    func getJobs(completion: @escaping (Result<Jobs, NetworkError>) -> Void) {
        let url = "https://ios-interview.joinhandshake-internal.com/jobs"
        networkController.get(urlString: url, completion: completion)
    }
}
