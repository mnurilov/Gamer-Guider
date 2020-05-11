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
    var filtered = [Game]()
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        mySearchBar.showsScopeBar = true
        mySearchBar.scopeButtonTitles = ["All", "PC", "PS4", "Xbox One", "Switch"]
        mySearchBar.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filtered.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame" {
            
            let viewToAnimate = UIView()

            UIView.animate(withDuration: 3) {

                viewToAnimate.alpha = 0

            }

            if let indexPath = self.myTableView.indexPathForSelectedRow {
                let controller = segue.destination as! GameViewController
                if let variableName = filtered[indexPath.row].name {
                    controller.name = variableName
                }
                else {
                    controller.name = ""
                }
                if let variableName = filtered[indexPath.row].id {
                    controller.id = variableName
                }
                else {
                    controller.id = 0
                }
                if let variableName = filtered[indexPath.row].first_release_date {
                    controller.first_release_date = variableName
                }
                else {
                    controller.first_release_date = 0
                }
                if let variableName = filtered[indexPath.row].cover {
                    controller.cover = variableName
                }
                else {
                    controller.cover = 0
                }
                if let variableName = filtered[indexPath.row].popularity {
                    controller.popularity = variableName
                }
                else {
                    controller.popularity = 0
                }
                if let variableName = filtered[indexPath.row].total_rating {
                    controller.total_rating = variableName
                }
                else {
                    controller.total_rating = 0
                }
                if let variableName = filtered[indexPath.row].summary {
                    controller.summary = variableName
                }
                else {
                    controller.summary = ""
                }
                if let variableName = filtered[indexPath.row].genres {
                    controller.genres = variableName
                }
                else {
                    controller.genres = []
                }
                if let variableName = filtered[indexPath.row].platforms {
                    controller.platforms = variableName
                }
                else {
                    controller.platforms = []
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameItem", for: indexPath)
        let nameLabel = cell.viewWithTag(100) as! UILabel
          
        let game = filtered[indexPath.row]
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
    
    /*func filtertableView(platform:Int){
        switch platform {
        case 0:
            let filtered = games.filter { $0.platforms?.contains(6) == true }

            
        default:
        }
    }*/
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("New scope index is now \(selectedScope)")
        
        switch selectedScope {
        case 0:
            // ALL
            filtered = games
            myTableView.reloadData()
        case 1:
            // PC
            filtered = games.filter { $0.platforms?.contains(6) == true }
            myTableView.reloadData()
        case 2:
            // PS4
            filtered = games.filter { $0.platforms?.contains(48) == true }
            myTableView.reloadData()
        case 3:
            // XBOX ONE
            filtered = games.filter { $0.platforms?.contains(49) == true }
            myTableView.reloadData()
        case 4:
            // SWITCH
            filtered = games.filter { $0.platforms?.contains(130) == true }
            myTableView.reloadData()
        default:
            print("Howd you get here?")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SEARCH BUTTON MOTHER FUCKIGN CLICKED")
        print(mySearchBar.text!)
        
        let session = URLSession.shared
        let url = URL(string: "https://api-v3.igdb.com/games/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        let body = "fields name,first_release_date,genres,platforms,popularity,total_rating,summary,cover; search \"\(mySearchBar.text!)\"; limit 100;".data(using: .utf8)!

        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let json_encoded = dataString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode([Game].self, from: json_encoded)
                    self.games = res
                    self.filtered = self.games
                    self.myTableView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }

        task.resume()
        
        /*let session = URLSession.shared
        let url = URL(string: "https://api-v3.igdb.com/search")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        let body = "fields name,game; search \"\(mySearchBar.text!)\"; limit 10;".data(using: .utf8)!
        
        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let json_encoded = dataString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode([Game].self, from: json_encoded)
                    self.games = res
                    self.myTableView.reloadData()

                    let url2 = URL(string: "https://api-v3.igdb.com/games")!
                    
                    var request2 = URLRequest(url: url2)
                    request2.httpMethod = "POST"
                    
                    request2.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
                    request2.setValue("text/plain", forHTTPHeaderField: "Content-Type")
                    
                    var ids = "";
                    
                    for g in self.games {
                        if let game_id = g.gameId {
                            ids += String(game_id) + ","
                        }
                    }
                    
                    ids = String(ids.dropLast())

                    var body2 = "fields name,first_release_date,genres,platforms,popularity,total_rating,summary,cover; where id = (\(ids));sort popularity desc; limit \(self.games.count)".data(using: .utf8)!
                    
                    print("MY REQUEST LETS SEE")
                    print(body2);
                    
                    let task2 = session.uploadTask(with: request2, from: body2) { data, response, error in
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
                    
                    task2.resume()
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }

        task.resume()*/
    }
    
    @IBAction func api_call() {
        print("Hello")
        let session = URLSession.shared
        let url = URL(string: "https://api-v3.igdb.com/games/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        let body = "fields name,first_release_date,genres,platforms,popularity,total_rating,summary,cover; sort popularity desc; limit 10;".data(using: .utf8)!

        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let json_encoded = dataString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode([Game].self, from: json_encoded)
                    self.games = res
                    self.filtered = self.games
                    self.myTableView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }

        task.resume()
    }


}

