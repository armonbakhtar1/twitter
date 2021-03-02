//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Armon Bakhtar on 2/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetsArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadTweet()
    }

    // MARK: - Table view data source
    
    let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    
    let params = ["counts": 10]
    
    func loadTweet(){
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets:[NSDictionary]) in
            self.tweetsArray.removeAll()
            for tweet in tweets{
                self.tweetsArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not get tweets")
        })
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let tweet = tweetsArray[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        
        
        // cell.userNameLabel.text = tweet["user"]["name"] as! String
        
        cell.userNameLabel.text = user["name"] as? String
        
        cell.tweetContent.text = tweet["text"] as? String
        
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetsArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetsArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetsArray[indexPath.row]["retweeted"] as! Bool)
        
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }




}
