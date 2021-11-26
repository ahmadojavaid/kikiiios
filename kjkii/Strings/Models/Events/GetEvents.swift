//
//  GetEvents.swift
//  kjkii
//
//  Created by Shahbaz on 19/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct GetEvents {
    init() {}
    static let shared = GetEvents()
    func getEvents(completion: @escaping(Result<AppEvents, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "events")
        HttpUtility.shared.getApiData(requestUrl: url!, resultType: AppEvents.self) { (result, done) in
            if done{
                guard let result = result else{
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
            else{
                completion(.failure(.invalidResponse))
            }
            
        }
    }
    

    
}




struct AppEvents: Codable {
    let nextOffset: Int
    let events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case nextOffset = "next_offset"
        case events
    }
}
struct SingleEvent: Codable {
    let success: Bool
    let events: SingleEventData
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case events
    }
}

// MARK: - Event
struct Event: Codable {
    let id: Int?
    let name, eventDescription, datetime: String?
    let coverPic: String?
    let userID: Int?
    let attendantsCount: Int?
    let attendants: [Attendant]
    let user: CommunityUser
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case eventDescription = "description"
        case datetime = "datetime"
        case coverPic = "cover_pic"
        case userID = "user_id"
        case attendantsCount = "attendants_count"
        case attendants = "attendants"
        case user = "user"
    }
}

// MARK: - Attendant
struct Attendant    : Codable {
    let name : String?
    let userID      : Int
    let profilePic  : String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case profilePic = "profile_pic"
        case name = "name"
    }
}


struct SingleEventData: Codable {
    let id: Int?
    let name: String?
    let description : String?
    let datetime : String?
    let coverPic: String?
    let userID: Int?
    let attendantsCount: Int?
    let attendants: [SingleAttendant]?
    let user: CommunityUser?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case datetime = "datetime"
        case coverPic = "cover_pic"
        case userID = "user_id"
        case attendantsCount = "attendants_count"
        case attendants = "attendants"
        case user = "user"
    }
}

// MARK: - Attendant
struct SingleAttendant    : Codable {
    let userID      : Int
    let profilePic  : String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case profilePic = "profile_pic"
        case name = "name"
    }
}




