//
//  Cover.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/17/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import Foundation

struct Cover: Codable {
    let id: Int
    let image_id: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case image_id = "image_id"
    }
}
