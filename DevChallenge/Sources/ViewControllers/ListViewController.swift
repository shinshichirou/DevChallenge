//
//  ListViewController.swift
//  DevChallenge
//
//  Created by Igor Tudoran on 10/16/18.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListViewController: UITableViewController {

    var bounds: Bounds! {
        didSet {
            currentIndex = bounds.lower
        }
    }
    
    private var commentArray = [Comment]()
    private let cellID = "CommentCell"
    private let dataManager = DataManager()
    
    private var currentIndex = 1
    private var requestsCount = 10
    
    private var isUpdating = false
    
    private let spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateData()
    }
    
    private func setupTableView() {
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44.0)
        self.tableView.tableFooterView = spinner
    }
    
    // Lazy updating table data & checks.
    private func updateData() {
        if isUpdating ||
            currentIndex >= bounds.upper {
            return
        }
        
        isUpdating = true
        spinner.isHidden = false
        
        var currentCount = requestsCount
        let checkCount = currentIndex + requestsCount
        if checkCount >= bounds.upper {
            currentCount = requestsCount - (checkCount - bounds.upper) + 1
        }
        
        dataManager.getCommentsFrom(currentIndex, count: currentCount) { comments in
            self.commentArray.append(contentsOf: comments)
            self.tableView.reloadData()
            self.currentIndex += currentCount
            
            self.isUpdating = false
            self.spinner.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                    for: indexPath) as? CommentCell {
            let comment = commentArray[indexPath.row]
            cell.nameLabel.text = comment.name
            cell.emailLabel.text = comment.email
            cell.bodyLabel.text = comment.body
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == commentArray.count-1 &&
            isUpdating == false {
            updateData()
        }
    }

}
