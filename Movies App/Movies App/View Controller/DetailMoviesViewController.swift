//
//  DetailMoviesViewController.swift
//  Movies App
//
//  Created by Nguyen Tan Dung on 30/11/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import UIKit

class DetailMoviesViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var background:String!
    var name:String!
    var vote:NSNumber!
    var overview:String!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!
    @IBOutlet weak var voteLbl: UILabel!
    
    override func viewDidLoad() {
        backgroundImage.sizeToFit()
        super.viewDidLoad()
        let url = URL(string: background)
        do{
            let d = try Data(contentsOf: url!)
            DispatchQueue.main.async {
            self.backgroundImage.image = UIImage(data: d)
            }
        }catch{
            print("error")
                }
        self.overviewLbl.text = "Description: " + overview
        self.nameLbl.text = "Movies: " + name
        self.voteLbl.text = "IMDB: " + vote.stringValue
                    }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


