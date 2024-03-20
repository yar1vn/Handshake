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
    
    private let jobViewModel: JobViewModel
    private let imageLoader: ImageLoader
    
    init?(job: Job, imageLoader: ImageLoader, coder: NSCoder) {
        self.jobViewModel = JobViewModel(job: job)
        self.imageLoader = imageLoader
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(jobViewModel)
    }
    
    private func bind(_ jobViewModel: JobViewModel) {
        jobTitleLabel.text = jobViewModel.job.title
        salaryLabel.text = jobViewModel.formattedSalary
        companyLabel.text = jobViewModel.job.employer.name
        addressLabel.text = jobViewModel.job.employer.address
        jobDescriptionLabel.text = jobViewModel.job.employer.description
        recruiterLabel.attributedText = jobViewModel.attributedRecruiterAndEmail
        
        Task {
            if let url = jobViewModel.job.employer.image {
                imageView.image = try await imageLoader.loadImage(for: url)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
