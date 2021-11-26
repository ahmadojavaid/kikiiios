//
//  BannerModel.swift
//  kjkii
//
//  Created by Saeed Rehman on 13/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import Foundation
struct BannerStruct : Codable {
    let success : Bool?
    let images : [BannerImages]?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case images = "images"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        images = try values.decodeIfPresent([BannerImages].self, forKey: .images)
    }
    
}
struct BannerImages : Codable {
    let id : Int?
    let path : String?
    let link : String?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case path = "path"
        case link = "link"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}
