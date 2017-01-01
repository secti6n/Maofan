//
//  HomeViewController.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/20.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit
import SwiftyJSON
import YYText

class HomeViewController: UITableViewController {

    func loadData() {
        PlaySound.load(.start)
        var parameters = [
            "format" : "html",
            "count" : "\(loadCount)",
            ]
        if let id = feeds.last?.id {
            parameters.updateValue(id, forKey: "max_id")
        }
        Service.sharedInstance.home_timeline(parameters: parameters, success: { (response) in
            Misc.markTime()
            var new: [Feed] = []
            for json in JSON(data: response.data).array! {
                new.append(Feed(json))
            }
            self.feeds += new
            Misc.markTime()
            PlaySound.load(.success)
        }, failure: { (error) in
            Misc.handleError(error)
            self.refreshControl?.endRefreshing()
        })
    }
    
    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        loadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return feeds[indexPath.row].feedCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.feed = feeds[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlaySound.touch()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        performSegue(withIdentifier: "Segue", sender: self)
    }
    
    var feeds: [Feed] = [] {
        didSet {
            let cells = tableView.visibleCells as! [FeedCell]
            for cell in cells {
                cell.label.displaysAsynchronously = false
            }
            self.tableView.reloadData()
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                for cell in cells {
                    cell.label.displaysAsynchronously = true
                }
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    var loadCount = 60

}
