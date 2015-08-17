//
//  ClubSearchCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/17/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClubSearchCTRL: UITableViewController,UISearchBarDelegate {
    
    var clubs: [Club] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        self.tableView.addGestureRecognizer(tap)
        
        searchBar.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return clubs.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ClubSearchCell
        
        let club = clubs[indexPath.row]
        
        cell.nameTXT.text = club.name
        cell.recordTXT.text = "\(club.wins)-\(club.losses)-\(club.otl)"
        cell.divisionTXT.text = "Division: \(club.division)"
        
        return cell
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchClubs()
        dismissKeyboard()
        
    }
    
    func searchClubs() -> Bool {
        
        if searchBar.text == "" { return false }
        
        Loading.start()
        
        let s = "https://www.easports.com/iframe/nhl14proclubs/api/platforms/xbox/clubsComplete/\(searchBar.text)"
        
        Alamofire.request(.GET, s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, parameters: nil)
            .responseJSON { request, response, data, error in
                
                if error == nil {
                    
                    if response?.statusCode == 200 {
                        
                        var json = JSON(data!)
                        
                        var tmp: [Club] = []
                        
                        for (key,val) in json["raw"] {
                            
                            let club = Club(json: val)
                            
                            tmp.append(club)
                            
                        }
                        
                        self.clubs = tmp
                        
                        self.tableView.reloadData()
                        
                    } else {
                        
                        println("Status Code Error: \(response?.statusCode)")
                        println(request)
                        
                    }
                    
                } else {
                    
                    println("Error!")
                    println(error)
                    println(request)
                    
                }
                
                Loading.stop()
                
        }
        
        return true
        
    }
    
    func dismissKeyboard(){
        
        searchBar.endEditing(true)
        
    }

}