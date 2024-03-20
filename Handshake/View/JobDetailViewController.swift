//
//  JobDetailViewController.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import UIKit

class JobDetailViewController: UIViewController {
    static let storyboardIdentifier = "JobDetail"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var recruiterLabel: UILabel!
    
    private let job: Job
    private let imageLoader: ImageLoader
    
    init?(job: Job, imageLoader: ImageLoader, coder: NSCoder) {
        self.job = job
        self.imageLoader = imageLoader
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(job: job)
    }
    
    private func bind(job: Job) {
        jobTitleLabel.text = job.title
        salaryLabel.text = job.salary
        companyLabel.text = job.employer.name
        addressLabel.text = job.employer.address
        jobDescriptionLabel.text = job.employer.description
        recruiterLabel.text = job.recruiter.firstName
        
        Task {
            if let url = job.employer.image {
                imageView.image = try await imageLoader.loadImage(for: url)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
