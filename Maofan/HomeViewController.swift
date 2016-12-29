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
    
    var feeds: [Feed] = []
    
    func loadData() {
        let parameters = [
            "format" : "html",
            "count" : "42",
            ]
        Service.sharedInstance.home_timeline(parameters: parameters, success: { (response) in
            var new: [Feed] = []
            for json in JSON(data: response.data).array! {
                new.append(Feed(json: json))
            }
            self.feeds = new
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }, failure: { (error) in
            Misc.handleError(error)
            self.refreshControl?.endRefreshing()
        })
    }
    
    override func viewDidLoad() {
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        loadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.feed = feeds[indexPath.row]
        return cell
    }
    
    @IBAction func test(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func testLoad(_ sender: Any) {
        loadData()
    }

}
