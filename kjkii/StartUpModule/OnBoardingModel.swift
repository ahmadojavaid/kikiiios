//
//  OnBoardingModel.swift
//  kjkii
//
//  Created by Saeed Rehman on 13/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import Foundation
struct OnBoardingStruct : Codable {
    let success : Bool?
    let images : [OnBoardingImages]?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case images = "images"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        images = try values.decodeIfPresent([OnBoardingImages].self, forKey: .images)
    }
    
}
struct OnBoardingImages : Codable {
    let id : Int?
    let title : String?
    let description : String?
    let path : String?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case description = "description"
        case path = "path"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}
