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
    private let companyImage: UIImage?
    
    init?(job: Job, companyImage: UIImage?, coder: NSCoder) {
        self.job = job
        self.companyImage = companyImage
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        bind(job: job, companyImage: companyImage)
    }
    
    private func bind(job: Job, companyImage: UIImage?) {
        imageView.image = companyImage
        jobTitleLabel.text = job.title
        salaryLabel.text = job.salary
        companyLabel.text = job.employer.name
        addressLabel.text = job.employer.address
        jobDescriptionLabel.text = job.employer.description
        recruiterLabel.text = job.recruiter.firstName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
