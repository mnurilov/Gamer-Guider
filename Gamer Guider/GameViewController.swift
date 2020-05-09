//
//  GameViewController.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/8/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameNameLabel: UILabel!
    var name: String = ""
    
    @IBOutlet weak var gameIDLabel: UILabel!
    var id: Int = 0
    
    @IBOutlet weak var gameCoverLabel: UILabel!
    var cover: Int = 0
    
    @IBOutlet weak var gamePopularityLabel: UILabel!
    var popularity: Double = 0
    
    @IBOutlet weak var gameSummaryLabel: UILabel!
    var summary: String = ""
    
    @IBOutlet weak var gameFirstReleaseDateLabel: UILabel!
    var first_release_date: Int = 0
    
    @IBOutlet weak var gameTotalRatingLabel: UILabel!
    var total_rating: Double = 0
    
    @IBOutlet weak var gameGenresLabel: UILabel!
    var genres: [Int] = []
    
    @IBOutlet weak var gamePlatformsLabel: UILabel!
    var platforms: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameNameLabel.text = name
        gameIDLabel.text = String(id)
        gameCoverLabel.text = String(cover)
        gamePopularityLabel.text = String(popularity)
        gameSummaryLabel.text = summary
        gameFirstReleaseDateLabel.text = String(first_release_date)
        gameTotalRatingLabel.text = String(total_rating)
        gameGenresLabel.text = "\(genres)"
        gamePlatformsLabel.text = "\(platforms)"
        
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

}
