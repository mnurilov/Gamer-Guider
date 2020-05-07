//
//  ViewController.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/5/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var myTableView: UITableView!
    var games = [Game]()
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        mySearchBar.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameItem", for: indexPath)
        let nameLabel = cell.viewWithTag(100) as! UILabel
          
          let game = games[indexPath.row]
          nameLabel.text = game.name
        
        // End of new code block
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*if mySearchBar.text == nil || mySearchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            myTableView.reloadData()
        }
        else{
            isSearching = true
        }*/
        print(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SEARCH BUTTON MOTHER FUCKIGN CLICKED")
        print(mySearchBar.text!)
        
        let session = URLSession.shared
        let url = URL(string: "https://api-v3.igdb.com/search")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        let body = "fields *; search \"\(mySearchBar.text!)\"; limit 10;".data(using: .utf8)!
        
        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let json_encoded = dataString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode([Game].self, from: json_encoded)
                    self.games = res
                    self.myTableView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }

        task.resume()
    }
    
    @IBAction func api_call() {
        print("Hello")
        let session = URLSession.shared
        let url = URL(string: "https://api-v3.igdb.com/games/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        let body = "fields name; sort popularity desc;".data(using: .utf8)!

        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let json_encoded = dataString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode([Game].self, from: json_encoded)
                    self.games = res
                    self.myTableView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }

        task.resume()
    }


}

