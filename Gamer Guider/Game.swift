//
//  Game.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/5/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import Foundation

struct Game: Codable {
    let name: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
