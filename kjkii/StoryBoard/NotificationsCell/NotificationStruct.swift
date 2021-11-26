//
//  NotificationStruct.swift
//  kjkii
//
//  Created by Saeed Rehman on 21/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import Foundation
struct NotificationStruct : Codable {
    let success : Bool?
    let notifications : [Notifications]?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case notifications = "notifications"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        notifications = try values.decodeIfPresent([Notifications].self, forKey: .notifications)
    }
    
}
struct NotificationData : Codable {
    let user : NotificationUser?
    
    enum CodingKeys: String, CodingKey {
        
        case user = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(NotificationUser.self, forKey: .user)
    }
    
}
struct Notifications : Codable {
    let id : String?
    let type : String?
    let notifiable_type : String?
    let notifiable_id : Int?
    let data : NotificationData?
    let read_at : String?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case notifiable_type = "notifiable_type"
        case notifiable_id = "notifiable_id"
        case data = "data"
        case read_at = "read_at"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        notifiable_type = try values.decodeIfPresent(String.self, forKey: .notifiable_type)
        notifiable_id = try values.decodeIfPresent(Int.self, forKey: .notifiable_id)
        data = try values.decodeIfPresent(NotificationData.self, forKey: .data)
        read_at = try values.decodeIfPresent(String.self, forKey: .read_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}
struct NotificationUser : Codable {
    let id : Int?
    let name : String?
    let profile_pic : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case profile_pic = "profile_pic"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
    }
    
}
