//
//  Photo.swift
//  Persistence-FileManager
//
//  Created by Sunni Tang on 9/30/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

struct Photo: Codable {

    
    static func decodePhotosFromData(from jsonData: Data) throws -> [Photo] {
        let response = try JSONDecoder().decode([Photo].self, from: jsonData)
        return response
    }
}
