//
//  ListDispatchViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ListDispatchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dispatchVCs = ["Dispath Home",
                       "Dispatch Create Message",
                       "Dispatch Select Group",
                       "Dispatch Compose Message",
                       "Dispatch Going Live",
                       "Dispatch Task",
                       "Dispatch Live Feed",
                       "Dispatch Facial",
                       "Dispatch Scan Result",
                       "Dispatch AR View"]
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Dispatch Page"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - UITableViewDataSource

extension ListDispatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dispatchVCs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dispatchVCs[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListDispatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showDispatchHomeSegue", sender: nil)
        case 1:
            performSegue(withIdentifier: "showDispatchCreateMessageSegue", sender: nil)
        case 2:
            performSegue(withIdentifier: "showDispatchSelectGroupSegue", sender: nil)
        case 3:
            performSegue(withIdentifier: "showComposeMessageSegue", sender: nil)
        case 4:
            performSegue(withIdentifier: "showDispatchGoingLiveSegue", sender: nil)
        case 5:
            performSegue(withIdentifier: "showDispatchTaskSegue", sender: nil)
        case 6:
            performSegue(withIdentifier: "showLiveFeedSegue", sender: nil)
        case 7:
            performSegue(withIdentifier: "showFacialRecognitionSegue", sender: nil)
        case 8:
            let scanResultsVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "ScanResultsVC")
            navigationController?.pushViewController(scanResultsVC, animated: true)
        case 9 :
            let aRViewVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "ARViewVC")
            navigationController?.pushViewController(aRViewVC, animated: true)
        default:
            break
        }
    }
}
