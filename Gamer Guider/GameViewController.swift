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
    
    var cover: Int = 0
    
    @IBOutlet weak var gameSummaryLabel: UILabel!
    var summary: String = ""
    
    @IBOutlet weak var gameFirstReleaseDateLabel: UILabel!
    var first_release_date: Int = 0
    
    @IBOutlet weak var gameTotalRatingLabel: UILabel!
    var total_rating: Double = 0
    
    @IBOutlet weak var gamePlatformsLabel: UILabel!
    var platforms: [Int] = []
    
    @IBOutlet weak var gameFavoriteButton: UIButton!
    
    weak var delegate: GameViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameNameLabel.text = name
        gameSummaryLabel.text = summary
        gameTotalRatingLabel.text = "Rating: " + String(total_rating)
        gamePlatformsLabel.text = "Platforms: " + "\(platforms)"
        gameFavoriteButton.setTitle(String(UserDefaults.standard.bool(forKey: "\(id)")), for: .normal)
        

        let date = Date(timeIntervalSince1970: Double(first_release_date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MM-dd-yyyy"

        let localDate = dateFormatter.string(from: date)
        
        gameFirstReleaseDateLabel.text = "Release Date: " + String(localDate)
        
    }
    
    @IBAction func go_back(){
        //delegate?.GameViewController(self, didFinishEditing: id, favorite: UserDefaults.standard.bool(forKey: "\(id)"))
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.GameViewController(self, didFinishEditing: id, favorite: UserDefaults.standard.bool(forKey: "\(id)"))

        super.viewDidDisappear(animated)
    }
    
    @IBAction func favorite_click(){
        gameFavoriteButton.shake()
        
        if UserDefaults.standard.bool(forKey: "\(id)") == false {
            UserDefaults.standard.set(true, forKey: "\(id)")
            gameFavoriteButton.setTitle("⭐️", for: .normal)
        }
        else{
            UserDefaults.standard.removeObject(forKey: "\(id)")
            gameFavoriteButton.setTitle(String(UserDefaults.standard.bool(forKey: "\(id)")), for: .normal)
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(1000))
    }
    
}
