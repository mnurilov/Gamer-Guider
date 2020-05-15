//
//  FavoritesViewController.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/9/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var myTableView: UITableView!
        
    var games = [Game]()
    
    var ids = ""
    
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.dataSource = self
        myTableView.delegate = self
        
        print("Start")
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if Int(key) != nil {
                ids += key + ","
                count += 1
            }
        }
        
        ids = String(ids.dropLast())
        print("IDS")
        print(ids)
        let session = URLSession.shared
        let url = URL(string: ApiManager.shared.baseURL + "games")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("37fb4484f0596a97d1fd1b576f2e1c80", forHTTPHeaderField: "user-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")

        let body = "fields name,first_release_date,genres,platforms,popularity,total_rating,summary,cover; where id = (\(ids));sort popularity desc; limit \(count);".data(using: .utf8)!
        
        print(body)
        
        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let json_encoded = dataString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode([Game].self, from: json_encoded)
                    self.games = res
                    
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        
        task.resume()

        // Do any additional setup after loading the view.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame" {
            if let indexPath = self.myTableView.indexPathForSelectedRow {
                let controller = segue.destination as! GameViewController
                if let variableName = games[indexPath.row].name {
                    controller.name = variableName
                }
                else {
                    controller.name = ""
                }
                if let variableName = games[indexPath.row].id {
                    controller.id = variableName
                }
                else {
                    controller.id = 0
                }
                if let variableName = games[indexPath.row].first_release_date {
                    controller.first_release_date = variableName
                }
                else {
                    controller.first_release_date = 0
                }
                if let variableName = games[indexPath.row].cover {
                    controller.cover = variableName
                }
                else {
                    controller.cover = 0
                }
                if let variableName = games[indexPath.row].popularity {
                    controller.popularity = variableName
                }
                else {
                    controller.popularity = 0
                }
                if let variableName = games[indexPath.row].total_rating {
                    controller.total_rating = variableName
                }
                else {
                    controller.total_rating = 0
                }
                if let variableName = games[indexPath.row].summary {
                    controller.summary = variableName
                }
                else {
                    controller.summary = ""
                }
                if let variableName = games[indexPath.row].genres {
                    controller.genres = variableName
                }
                else {
                    controller.genres = []
                }
                if let variableName = games[indexPath.row].platforms {
                    controller.platforms = variableName
                }
                else {
                    controller.platforms = []
                }
            }
        }
    }

}
