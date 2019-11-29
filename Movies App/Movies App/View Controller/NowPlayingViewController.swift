//
//  NowPlayingViewController.swift
//  Movies App
//
//  Created by Nguyen Tan Dung on 11/29/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .black
        return refresh
    }()
    
    var movies: [NSDictionary]?
    @IBOutlet weak var nowPlayingTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowPlayingTbl.dataSource = self
        nowPlayingTbl.delegate = self
        
        nowPlayingTbl.refreshControl = refresh
        fetchMovies()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nowPlayingTbl.dequeueReusableCell(withIdentifier: "NowPlayingCell") as! NowPlayCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.lblTitle.text = overview
        cell.lblOverview.text = overview
        return cell
    }
    
    func fetchMovies() {
        let apiKey = "7eeded1f85c7960423f3d3eb5ca41634"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1")
        let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionTask = session.dataTask(with: request, completionHandler: {
            (dataOrNil, response, error) in if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
                    print("response \(responseDictionary)")
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.nowPlayingTbl.reloadData()
                }
            }
        })
        task.resume()
    }

}
