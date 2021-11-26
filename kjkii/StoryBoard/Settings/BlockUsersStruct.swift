//
//  BlockUsersStruct.swift
//  kjkii
//
//  Created by Saeed Rehman on 19/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import Foundation
struct BlockUsersStruct : Codable {
    let success : Bool?
    let blocked_users : [Blocked_users]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case blocked_users = "blocked_users"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        blocked_users = try values.decodeIfPresent([Blocked_users].self, forKey: .blocked_users)
    }

}
struct Blocked_users : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let email_verified_at : String?
    let phone : String?
    let phone_verified : Int?
    let role : String?
    let profile_pic : String?
    let birthday : String?
    let upgraded : Int?
    let incognito : Int?
    let show_location : Int?
    let gender_identity : String?
    let sexual_identity : String?
    let pronouns : String?
    let bio : String?
    let relationship_status : String?
    let height : String?
    let looking_for : String?
    let drink : String?
    let smoke : String?
    let cannabis : String?
    let political_views : String?
    let religion : String?
    let diet_like : String?
    let sign : String?
    let pets : String?
    let kids : String?
    let facebook : String?
    let instagram : String?
    let tiktok : String?
    let last_online : String?
    let latitude : String?
    let longitude : String?
    let auth_token : String?
    let device_token : String?
    let device_type : String?
    let status : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case email_verified_at = "email_verified_at"
        case phone = "phone"
        case phone_verified = "phone_verified"
        case role = "role"
        case profile_pic = "profile_pic"
        case birthday = "birthday"
        case upgraded = "upgraded"
        case incognito = "incognito"
        case show_location = "show_location"
        case gender_identity = "gender_identity"
        case sexual_identity = "sexual_identity"
        case pronouns = "pronouns"
        case bio = "bio"
        case relationship_status = "relationship_status"
        case height = "height"
        case looking_for = "looking_for"
        case drink = "drink"
        case smoke = "smoke"
        case cannabis = "cannabis"
        case political_views = "political_views"
        case religion = "religion"
        case diet_like = "diet_like"
        case sign = "sign"
        case pets = "pets"
        case kids = "kids"
        case facebook = "facebook"
        case instagram = "instagram"
        case tiktok = "tiktok"
        case last_online = "last_online"
        case latitude = "latitude"
        case longitude = "longitude"
        case auth_token = "auth_token"
        case device_token = "device_token"
        case device_type = "device_type"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        email_verified_at = try values.decodeIfPresent(String.self, forKey: .email_verified_at)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        phone_verified = try values.decodeIfPresent(Int.self, forKey: .phone_verified)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
        upgraded = try values.decodeIfPresent(Int.self, forKey: .upgraded)
        incognito = try values.decodeIfPresent(Int.self, forKey: .incognito)
        show_location = try values.decodeIfPresent(Int.self, forKey: .show_location)
        gender_identity = try values.decodeIfPresent(String.self, forKey: .gender_identity)
        sexual_identity = try values.decodeIfPresent(String.self, forKey: .sexual_identity)
        pronouns = try values.decodeIfPresent(String.self, forKey: .pronouns)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        relationship_status = try values.decodeIfPresent(String.self, forKey: .relationship_status)
        height = try values.decodeIfPresent(String.self, forKey: .height)
        looking_for = try values.decodeIfPresent(String.self, forKey: .looking_for)
        drink = try values.decodeIfPresent(String.self, forKey: .drink)
        smoke = try values.decodeIfPresent(String.self, forKey: .smoke)
        cannabis = try values.decodeIfPresent(String.self, forKey: .cannabis)
        political_views = try values.decodeIfPresent(String.self, forKey: .political_views)
        religion = try values.decodeIfPresent(String.self, forKey: .religion)
        diet_like = try values.decodeIfPresent(String.self, forKey: .diet_like)
        sign = try values.decodeIfPresent(String.self, forKey: .sign)
        pets = try values.decodeIfPresent(String.self, forKey: .pets)
        kids = try values.decodeIfPresent(String.self, forKey: .kids)
        facebook = try values.decodeIfPresent(String.self, forKey: .facebook)
        instagram = try values.decodeIfPresent(String.self, forKey: .instagram)
        tiktok = try values.decodeIfPresent(String.self, forKey: .tiktok)
        last_online = try values.decodeIfPresent(String.self, forKey: .last_online)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        auth_token = try values.decodeIfPresent(String.self, forKey: .auth_token)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}
