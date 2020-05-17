//
//  GameViewController.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/8/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

protocol GameViewControllerDelegate: class {
    func GameViewController(_ controller: GameViewController, didFinishEditing id: Int, favorite: Bool)
}

class GameViewController: UIViewController {
    @IBOutlet weak var gameNameLabel: UILabel!
    var name: String = ""
    
    var id: Int = 0
    
    @IBOutlet weak var gameSummaryLabel: UILabel!
    var summary: String = ""
    
    @IBOutlet weak var gameFirstReleaseDateLabel: UILabel!
    var first_release_date: Int = 0
    
    @IBOutlet weak var gameTotalRatingLabel: UILabel!
    var total_rating: Double = 0
    
    @IBOutlet weak var gamePlatformsLabel: UILabel!
    var platforms: [Platform] = []
    
    @IBOutlet weak var gameFavoriteButton: UIButton!
    
    @IBOutlet weak var coverImage: UIImageView!
    
    weak var delegate: GameViewControllerDelegate?
    
    var cover: Cover!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameNameLabel.text = name
        gameSummaryLabel.text = summary
        total_rating = Double(floor(pow(10.0, Double(2)) * total_rating) / pow(10.0, Double(2)))
        gameTotalRatingLabel.text = "Rating: " + String(total_rating)
        
        var platforms_string = "Platforms: "
        for platform in platforms {
            platforms_string += platform.name + ", "
        }
        gamePlatformsLabel.text = String(platforms_string.dropLast(2))
        
        let date = Date(timeIntervalSince1970: Double(first_release_date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let localDate = dateFormatter.string(from: date)
        
        gameFirstReleaseDateLabel.text = "Release Date: " + String(localDate)
        
        if UserDefaults.standard.bool(forKey: "\(id)") == true {
            UserDefaults.standard.set(true, forKey: "\(id)")
            gameFavoriteButton.setImage(imgFavorite, for: .normal)
        }
        else{
            UserDefaults.standard.removeObject(forKey: "\(id)")
            gameFavoriteButton.setImage(imgUnFavorite, for: .normal)
        }
        
        let image_url = URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/\(cover.image_id).jpg")!
        coverImage.downloaded(from: image_url)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.GameViewController(self, didFinishEditing: id, favorite: UserDefaults.standard.bool(forKey: "\(id)"))

        super.viewDidDisappear(animated)
    }
    
    let imgFavorite = UIImage(named:"gold_star.png")
    let imgUnFavorite = UIImage(named:"black_star.png")

    @IBAction func favorite_click(){
        gameFavoriteButton.shake()
        
        if UserDefaults.standard.bool(forKey: "\(id)") == false {
            UserDefaults.standard.set(true, forKey: "\(id)")
            gameFavoriteButton.setImage(imgFavorite, for: .normal)
        }
        else{
            UserDefaults.standard.removeObject(forKey: "\(id)")
            gameFavoriteButton.setImage(imgUnFavorite, for: .normal)
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(1000))
    }
    
}
