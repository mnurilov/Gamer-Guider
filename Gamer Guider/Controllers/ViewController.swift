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
    
    var currentScope = 0
    
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var myFavoritesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        mySearchBar.showsScopeBar = true
        mySearchBar.scopeButtonTitles = ["All", "PC", "PS4", "Xbox One", "Switch"]
        mySearchBar.delegate = self
        
        api_call()
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
        let coverImage = cell.viewWithTag(200) as! UIImageView
        
        let game = filtered[indexPath.row]
        nameLabel.text = game.name
        
        let image_url = URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/\(game.cover!.image_id).jpg")!
        coverImage.downloaded(from: image_url)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("New scope index is now \(selectedScope)")
        
        currentScope = selectedScope
        
        switch selectedScope {
        case 0:
            // ALL
            filtered = games
            myTableView.reloadData()
        case 1:
            // PC
            filtered = games.filter { $0.platforms?.contains(where: { platform in platform.id == 6 }) == true }
            myTableView.reloadData()
        case 2:
            // PS4
            filtered = games.filter { $0.platforms?.contains(where: { platform in platform.id == 48 }) == true }
            myTableView.reloadData()
        case 3:
            // XBOX ONE
            filtered = games.filter { $0.platforms?.contains(where: { platform in platform.id == 49 }) == true }
            myTableView.reloadData()
        case 4:
            // SWITCH
            filtered = games.filter { $0.platforms?.contains(where: { platform in platform.id == 130 }) == true }
            myTableView.reloadData()
        default:
            print("Howd you get here?")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(mySearchBar.text!)
        
        let session = URLSession.shared
        let url = URL(string: ApiManager.shared.baseURL + "games")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        let body = "fields name,first_release_date,genres,platforms.name,popularity,total_rating,summary,cover.image_id; search \"\(mySearchBar.text!)\"; where cover != null; limit 100;".data(using: .utf8)!

        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let json_encoded = dataString.data(using: .utf8)!
                
                do {
                    
                    let res = try JSONDecoder().decode([Game].self, from: json_encoded)
                    self.games = res
                    
                    switch self.currentScope {
                    case 0:
                        // ALL
                        self.filtered = self.games
                    case 1:
                        // PC
                        self.filtered = self.games.filter { $0.platforms?.contains(where: { platform in platform.id == 6 }) == true }
                    case 2:
                        // PS4
                        self.filtered = self.games.filter { $0.platforms?.contains(where: { platform in platform.id == 48 }) == true }
                    case 3:
                        // XBOX ONE
                        self.filtered = self.games.filter { $0.platforms?.contains(where: { platform in platform.id == 49 }) == true }
                    case 4:
                        // SWITCH
                        self.filtered = self.games.filter { $0.platforms?.contains(where: { platform in platform.id == 130 }) == true }
                    default:
                        print("Howd you get here?")
                    }
                    
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
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
        let url = URL(string: ApiManager.shared.baseURL + "games")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        let body = "fields name,first_release_date,genres,platforms.name,popularity,total_rating,summary,cover.image_id; where cover != null; where rating > 0; sort rating desc; limit 100;".data(using: .utf8)!

        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let json_encoded = dataString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode([Game].self, from: json_encoded)
                    self.games = res
                    self.filtered = self.games
                    
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }

        task.resume()
    }
    
}

