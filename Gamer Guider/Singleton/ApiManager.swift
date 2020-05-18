//
//  ApiManager.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/15/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager(baseURL: "https://api-v3.igdb.com/")
    
    let baseURL: String

    private init(baseURL: String) {
        self.baseURL = baseURL
    }
}
