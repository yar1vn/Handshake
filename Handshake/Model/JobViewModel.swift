//
//  JobViewModel.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import Foundation

struct JobViewModel {
    let job: Job
    
    // formatted properties
    let formattedSalary: String
    let formattedRecruiter: String
    let formattedEmail: NSAttributedString?
    let attributedRecruiterAndEmail: NSAttributedString?
    
    static let numberFromStringFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(job: Job) {
        self.job = job
        
        if let numberSalary = Self.numberFromStringFormatter.number(from: job.salary) {
            formattedSalary = NumberFormatter.localizedString(from: numberSalary, number: .currency)
        } else {
            formattedSalary = job.salary
        }
        
        formattedRecruiter = PersonNameComponentsFormatter.localizedString(
            from: .init(givenName: job.recruiter.firstName, familyName: job.recruiter.lastName),
            style: .default
        )
        
        formattedEmail = try? NSAttributedString(markdown: "[\(job.recruiter.emailAddress)](mailto:\(job.recruiter.emailAddress))")
        
        if let formattedEmail {
            let attributedString = NSMutableAttributedString(string: formattedRecruiter.appending(" "))
            attributedString.append(formattedEmail)
            attributedRecruiterAndEmail = attributedString
        } else {
            attributedRecruiterAndEmail = nil
        }
    }
}
