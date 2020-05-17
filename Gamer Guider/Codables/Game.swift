//
//  Game.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/5/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import Foundation

struct Game: Codable {
    let name: String?
    let id: Int?
    let first_release_date: Int?
    let popularity: Double?
    let total_rating: Double?
    let summary: String?
    let cover: Cover?
    let platforms: [Platform]?
    let genres: [Int]?
    let gameId: Int?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case cover = "cover"
        case summary = "summary"
        case total_rating = "total_rating"
        case first_release_date = "first_release_date"
        case popularity = "popularity"
        case platforms = "platforms"
        case genres = "genres"
        case gameId = "game"
        case url = "image_id"
    }
}
