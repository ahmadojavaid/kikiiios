//
//  SendMessage.swift
//  kjkii
//
//  Created by Shahbaz on 29/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct SendMessage : Codable {
    var body        = String()
    var receiver_id = String()
    func sendMsg(completion : @escaping(_ done: Bool)->Void){
        do {
            let url = URL(string: EndPoints.BASE_URL + "send/message")!
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: MessageSend.self) { (result) in
                guard let _ = result else{
                    completion(false)
                    return
                }
                completion(true)
            }
        } catch (_)
        {
            print("Message chould not me sent")
        }
    }
}

struct SecondSendMessage : Codable {
    var body        = String()
    var receiver_id = String()
    var conversation_id = String()
    func sendMsg(completion : @escaping(_ done: Bool)->Void){
        do {
            let url = URL(string: EndPoints.BASE_URL + "send/message")!
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: MessageSend.self) { (result) in
                guard let _ = result else{
                    completion(false)
                    return
                }
                completion(true)
            }
        } catch (_)
        {
            print("Message chould not me sent")
        }
    }
}

struct MessageSend : Codable {
    let success : Bool?
    let message : String?
    let data    : MsgData?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(MsgData.self, forKey: .data)
    }
}

struct MsgData : Codable {
    let id                  : Int?
    let body                : String?
    let sender_id           : Sender_id?
    let receiver_id         : Receiver_id?
    let conversation_id     : String?
    let read_at             : String?
    let created_at          : String?
    let updated_at          : String?
    //let media               : String?
    enum CodingKeys: String, CodingKey {
        case id                     = "id"
        case body                   = "body"
        case sender_id              = "sender_id"
        case receiver_id            = "receiver_id"
        case conversation_id        = "conversation_id"
        case read_at                = "read_at"
        case created_at             = "created_at"
        case updated_at             = "updated_at"
        //case media                  = "media"
    }
    
    init(from decoder: Decoder) throws {
        let values      = try decoder.container(keyedBy: CodingKeys.self)
        id              = try values.decodeIfPresent(Int.self, forKey: .id)
        body            = try values.decodeIfPresent(String.self, forKey: .body)
        sender_id       = try values.decodeIfPresent(Sender_id.self, forKey: .sender_id)
        receiver_id     = try values.decodeIfPresent(Receiver_id.self, forKey: .receiver_id)
        conversation_id = try values.decodeIfPresent(String.self, forKey: .conversation_id)
        read_at         = try values.decodeIfPresent(String.self, forKey: .read_at)
        created_at      = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at      = try values.decodeIfPresent(String.self, forKey: .updated_at)
        //media           = try values.decodeIfPresent(String.self, forKey: .media)
    }
}

struct Receiver_id : Codable {
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

struct Sender_id : Codable {
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



