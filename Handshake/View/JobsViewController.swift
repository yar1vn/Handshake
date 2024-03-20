//
//  ViewController.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import UIKit

private enum State {
    case loaded(jobs: Jobs)
    case loading
    case empty
    case error(Error)

    init(_ jobs: Jobs) {
        if jobs.isEmpty { self = .empty }
        else { self = .loaded(jobs: jobs) }
    }

    var count: Int {
        switch self {
        case .loaded(let jobs): return jobs.count
        default: return 0
        }
    }
}

class JobsViewController: UITableViewController {
    private let api: JobsAPI = JobsAPIImpl()
    private let imageLoader: ImageLoader = ImageLoaderImpl()
    
    private var state: State = .empty {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                // TODO: self.showEmptyOrErrorState()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        getJobs()
    }
    
    @objc private func getJobs() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()
        }
        
        Task {
            do {
                state = .loading
                let jobs = try await api.getJobs()
                state = State(jobs)
                
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
            } catch {
                state = .error(error)
            }
        }
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(getJobs),
                                            for: .valueChanged)
    }
}

class JobCell: UITableViewCell {
    static let reusableIdentifier = "job"
    
    @IBOutlet var jobImageView: UIImageView!
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var employerLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    func bind(job: Job) {
        jobTitleLabel.text = job.title
        employerLabel.text = job.employer.name
    }
}


// MARK: UITableViewController

extension JobsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .loaded(jobs) = state else { return }
        let job = jobs[indexPath.item]
        
        guard let jobDetailsViewController = storyboard?.instantiateViewController(identifier: JobDetailViewController.storyboardIdentifier, creator: { [unowned self] coder in
            JobDetailViewController(job: job, imageLoader: self.imageLoader, coder: coder)
        }) else {
            fatalError("Cannot instantiate JobDetailViewController")
        }
        
        show(jobDetailsViewController, sender: tableView.cellForRow(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobCell.reusableIdentifier, for: indexPath) as! JobCell
        
        guard case let .loaded(jobs) = state else {
            return cell
        }
        
        let job = jobs[indexPath.row]
        cell.bind(job: job)
        
        Task {
            try await loadImage(for: job, at: indexPath)
        }
        return cell
    }
    
    private func loadImage(for job: Job, at indexPath: IndexPath) async throws {
        guard let url = job.employer.image else { return }
        
        // hit the cache before making a network call
        if let image = imageLoader[url] {
            let cell = tableView.cellForRow(at: indexPath) as! JobCell
            cell.jobImageView.image = image
        } else {
            try await imageLoader.loadImage(for: url)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}
