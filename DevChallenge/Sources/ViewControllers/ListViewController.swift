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

    var bounds: Bounds!
    private var comments = [JSON]()
    private let cellID = "CommentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        loadComments()
    }
    
    private func loadComments() {
        showHUD()
        API.shared.request(.getComments()) { (json, error) in
            self.comments = json.arrayValue.filter {
                $0["id"].intValue >= self.bounds.lower &&
                    $0["id"].intValue <= self.bounds.upper
                }
                .sorted()
            self.tableView.reloadData()
            self.hideHUD()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                    for: indexPath) as? CommentCell {
            let comment = comments[indexPath.row]
            cell.nameLabel.text = comment["name"].stringValue
            cell.emailLabel.text = comment["email"].stringValue
            cell.bodyLabel.text = comment["body"].stringValue
            return cell
        }
        return UITableViewCell()
    }

}
