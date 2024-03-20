//
//  JobsAPI.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import Foundation
import UIKit.UIImage

enum Endpoint: String {
    case jobs = "jobs"
    
    func getURL(baseURL: String) -> String {
        return baseURL.appending("\(self)")
    }
}

protocol JobsAPI {
    var networkController: NetworkController { get }
    var baseURL: String { get }
    
    func getJobs() async throws -> Jobs
    func getImage(for url: URL) async throws -> UIImage?
}

class JobsAPIImpl: JobsAPI {
    static let defaultURL = "https://ios-interview.joinhandshake-internal.com/"
    
    let networkController: NetworkController
    let baseURL: String

    init(baseURL: String = defaultURL,
         networkController: NetworkController = NetworkControllerImpl()) {
        self.baseURL = baseURL
        self.networkController = networkController
    }

    func getJobs() async throws -> Jobs {
        return try await networkController.get(urlString: Endpoint.jobs.getURL(baseURL: baseURL))
    }

    func getImage(for url: URL) async throws -> UIImage? {
        try await networkController.getImage(url: url)
    }
}
