//
//  Model.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import Foundation

typealias Jobs = [Job]

struct Job: Codable {
    let id: Int
    let title: String
    let salary: String
    let employer: Employer
    let recruiter: Recruiter
}

struct Employer: Codable {
    let name: String
    let address: String
    let description: String
    let image: URL?
}

struct Recruiter: Codable {
    let firstName: String
    let lastName: String
    let emailAddress: String
}
