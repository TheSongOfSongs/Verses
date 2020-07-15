//
//  Verse.swift
//  verses
//
//  Created by Jinhyang on 2020/06/30.
//  Copyright © 2020 Jinhyang. All rights reserved.
//

import Foundation

struct Verse: Codable {
    let id: String
    let part: [String]
    let location: String
    
    static var id: Int = 0
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["id": id, "part": part, "location": location]
        return dict
    }
}
