//
//  GetConversations.swift
//  kjkii
//
//  Created by Shahbaz on 26/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct GetConversations {
    init() {
    }
    static let shared = GetConversations()
    func getConversations(completion: @escaping(Result<ConvestionResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "conversations")!
        HttpUtility.shared.getApiData(requestUrl: url, resultType: ConvestionResponse.self) { (result, done) in
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





struct ConvestionResponse : Codable {
    let success : Bool?
    let message : String?
    let next_offset : Int?
    let online_users : [Online_users]?
    let conversations : [Conversations]?

    enum CodingKeys: String, CodingKey {

        case success        = "success"
        case message        = "message"
        case next_offset    = "next_offset"
        case online_users   = "online_users"
        case conversations  = "conversations"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        next_offset = try values.decodeIfPresent(Int.self, forKey: .next_offset)
        online_users = try values.decodeIfPresent([Online_users].self, forKey: .online_users)
        conversations = try values.decodeIfPresent([Conversations].self, forKey: .conversations)
    }
}

struct Online_users : Codable {
    var id: String?
}


struct Conversations : Codable {
    let id : Int?
    let participant_1_id : String?
    let participant_2_id : String?
    let deleted_by_user_id : String?
    let created_at : String?
    let updated_at : String?
    let participant_1 : Participant_1?
    let participant_2 : Participant_2?
    let messages : [Messages]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case participant_1_id = "participant_1_id"
        case participant_2_id = "participant_2_id"
        case deleted_by_user_id = "deleted_by_user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case participant_1 = "participant_1"
        case participant_2 = "participant_2"
        case messages = "messages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        participant_1_id = try values.decodeIfPresent(String.self, forKey: .participant_1_id)
        participant_2_id = try values.decodeIfPresent(String.self, forKey: .participant_2_id)
        deleted_by_user_id = try values.decodeIfPresent(String.self, forKey: .deleted_by_user_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        participant_1 = try values.decodeIfPresent(Participant_1.self, forKey: .participant_1)
        participant_2 = try values.decodeIfPresent(Participant_2.self, forKey: .participant_2)
        messages = try values.decodeIfPresent([Messages].self, forKey: .messages)
    }

}

struct Messages : Codable {
    let id : Int?
    let body : String?
    let conversation_id : String?
    let read_at : String?
    //let media : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case body = "body"
        case conversation_id = "conversation_id"
        case read_at = "read_at"
        //case media = "media"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        conversation_id = try values.decodeIfPresent(String.self, forKey: .conversation_id)
        read_at = try values.decodeIfPresent(String.self, forKey: .read_at)
        //media = try values.decodeIfPresent(String.self, forKey: .media)
    }

}

struct Participant_1 : Codable {
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

struct Participant_2 : Codable {
    let id : Int?
    let name : String?
    let profile_pic : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case profile_pic = "profile_pic"
    }

    init(from decoder: Decoder) throws {
        let values      = try decoder.container(keyedBy: CodingKeys.self)
        id              = try values.decodeIfPresent(Int.self, forKey: .id)
        name            = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic     = try values.decodeIfPresent(String.self, forKey: .profile_pic)
    }

}



struct FireBaseMessage{
    var deviceType      : String
    var message         : String
    var messageBy       : String
    var recordingTime   : String
    var seen            : String
    var time            : String
    var type            : String
    var userId          : String
    var isSelected      : Bool
    var messageId       : String
}
