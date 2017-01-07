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
import YYWebImage

class HomeViewController: UITableViewController {

    func loadData() {
        PlaySound.load(.start)
        var parameters = [
            "format" : "html",
            "count" : "\(loadCount)",
            "id" : "tisafu",
            ]
        if let id = feeds.last?.id {
            parameters.updateValue(id, forKey: "max_id")
        }
        Service.sharedInstance.user_timeline(parameters: parameters, success: { (response) in
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
        Login.xauth(username: FanfouConsumer.username, password: FanfouConsumer.password)
        if let account = CoreDataTool.sharedInstance.fetch().first {
            let photo = User(JSON(data: account.jsonData as! Data)).avatar!
            print(photo)
            YYWebImageManager.shared().requestImage(with: photo, progress: nil, transform: nil, completion: { (image, url, type, stage, error) in
                let button = UIButton()
                button.frame.size = image!.size
                button.imageView?.image = image?.withRenderingMode(.alwaysOriginal)
                button.layer.cornerRadius = button.frame.width / 2
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            })
        }
        let home = UIImage(named: "home")
        let post = UIImage(named: "post")
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: home, style: .plain, target: nil, action: nil),  UIBarButtonItem(image: post, style: .plain, target: nil, action: nil)]
        refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        loadData()
//        let debugOptions = YYTextDebugOption()
//        debugOptions.baselineColor = .red
//        debugOptions.ctFrameBorderColor = .red
//        debugOptions.cgGlyphBorderColor = .cyan
//        YYTextDebugOption.setShared(debugOptions)
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
                cell.isLabelAsync = false
            }
            self.tableView.reloadData()
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                for cell in cells {
                    cell.isLabelAsync = true
                }
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    var loadCount = 60

}
