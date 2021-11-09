//
//  TaskViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    let tasks = ["School Check", "School Check 2", "Call In "]
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Task"

        createBackBarButtonItem()
        resetNavigationBar()
        prepareNavigationBar()
    }
    
    // MARK: - Methods
    
    @objc func newButtonAction() {
        
    }
    
    // MARK: - Private methods
    
    private func prepareNavigationBar() {
        let newButton = creatCustomBarButton(title: "New")
        newButton.addTarget(self, action: #selector(newButtonAction), for: .touchUpInside)
        
        let newBarButtonItem = UIBarButtonItem(customView: newButton)
        navigationItem.rightBarButtonItem = newBarButtonItem
    }
}

// MARK: - UITableViewDataSource

extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.taskNameLabel.text = tasks[indexPath.row]
        cell.radiusImageView.image = UIImage(named: indexPath.row == tasks.count - 1 ? "call-white" : "radius")
        cell.routeLabel.text = indexPath.row == tasks.count - 1 ? "Call" : "Route"
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        if indexPath.row != tasks.count - 1 {
            let routesVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "RoutesViewController") as! RoutesViewController
            routesVC.taskName = task
            
            navigationController?.pushViewController(routesVC, animated: true)
        }
    }
}
