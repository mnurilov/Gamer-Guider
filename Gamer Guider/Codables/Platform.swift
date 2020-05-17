//
//  Platform.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/17/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import Foundation

struct Platform: Codable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
