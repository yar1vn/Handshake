//
//  ViewController.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import UIKit

class JobsViewController: UIViewController {

    let api: JobsAPI = JobsAPIImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.getJobs { result in
            do {
                let jobs = try result.get()
                print(jobs)
            } catch {
                print(error)
            }
        }
    }


}
