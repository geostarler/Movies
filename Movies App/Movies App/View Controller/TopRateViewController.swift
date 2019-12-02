//
//  TopRateViewController.swift
//  Movies App
//
//  Created by Nguyen Tan Dung on 11/29/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
// Done: 8/10 require
// Search and load more are not working

import UIKit

class TopRateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    @IBOutlet weak var topRateTbl: UITableView!
    //refresh data
       lazy var refresh: UIRefreshControl = {
           let refresh = UIRefreshControl()
           refresh.tintColor = .black
           refresh.addTarget(self, action: #selector(requestData), for: .valueChanged)
           return refresh
       }()
       
       @objc
       func requestData() {
           DispatchQueue.main.async{
               self.topRateTbl.reloadData()
               self.refresh.endRefreshing()
           }
           
       }
       //show loading icon when load data
       
       //search movie
  
       func showSearchBar(){
           let searchController = UISearchController(searchResultsController: nil)
           navigationItem.searchController = searchController
           searchController.searchBar.delegate = self
       }
       
       var loading: UIActivityIndicatorView = UIActivityIndicatorView()
        
       var movies: [NSDictionary]?
    //main action
       override func viewDidLoad() {
           super.viewDidLoad()
           loading.center = self.view.center
           loading.hidesWhenStopped = true
           loading.style = UIActivityIndicatorView.Style.medium
           self.view.addSubview(loading)
           loading.startAnimating()
           topRateTbl.rowHeight = 180
           topRateTbl.dataSource = self
           topRateTbl.delegate = self
           topRateTbl.refreshControl = refresh
           showSearchBar()
           if CheckInternet.Connection(){
                    fetchMovies()
                }else{
                    self.alert(message: "Your Device is not connected with internet")
                }
               
       }

        //alert
        func alert(message: String) -> UIAlertController {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return alert
        }
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return movies?.count ?? 0
       }
       //load data on tableview
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = topRateTbl.dequeueReusableCell(withIdentifier: "TopRateCell") as! TopRateCell
            let movie = movies![indexPath.row]
            let title = movie["title"] as! String
            let overview = movie["overview"] as! String
            let imageview = movie["poster_path"] as! String
            cell.lblTitle.text = title
            cell.lblOverview.text = overview
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let imageUrl = URL(string: baseURL + imageview)
            let queue = DispatchQueue(label: "loadImage")
            queue.async{
                   do{
                       let d = try Data(contentsOf: imageUrl!)
                       DispatchQueue.main.async {
                        cell.moviesImage.image = UIImage(data: d)
                           }
                       }catch{
                           print("error")
                               }
                }
        loading.stopAnimating()
           return cell
           
       }
       //get api from db
       func fetchMovies() {
           let apiKey = "7eeded1f85c7960423f3d3eb5ca41634"
           let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-US")
           let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
           let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
           let task: URLSessionTask = session.dataTask(with: request, completionHandler: {
               (dataOrNil, response, error) in if let data = dataOrNil {
                   if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
                       self.movies = responseDictionary["results"] as? [NSDictionary]
                       self.topRateTbl.reloadData()
                   }
               }
           })
           task.resume()
       }
       //show detail movie
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let sb = UIStoryboard(name: "Main", bundle: nil)
           let movie = movies![indexPath.row]
           let baseURL = "https://image.tmdb.org/t/p/w500"
           let backdrop = movie["backdrop_path"] as! String
           let backgroundUrl = (baseURL + backdrop)
           let DetailView = sb.instantiateViewController(identifier: "DetailView") as! DetailMoviesViewController
           let name = movie["title"] as! String
           let detail = movie["overview"] as! String
           let vote = movie["vote_average"] as! NSNumber
           DetailView.background = backgroundUrl
           DetailView.name = name
           DetailView.overview = detail
           DetailView.vote = vote
               self.navigationController?.pushViewController(DetailView, animated: true)
       }
}
