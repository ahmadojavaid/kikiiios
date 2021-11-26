//
//  MyFriends.swift
//  kjkii
//
//  Created by Shahbaz on 02/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation

struct MyFriends {
    static let shared = MyFriends()
    init() { }
    func getMyFriends(url: String, completion: @escaping(Result<FrindRequest, ErrorMessage>)->Void){
        
        print(url)
        HttpUtility.shared.getApiDataWithOtherToken(requestUrl: URL(string : url)!, resultType: FrindRequest.self) { (result) in
            guard let result = result else {
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(result))
        }
    }
    
    func getMyRequests(completion: @escaping(Result<FrindRequest, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "pending/requests")
        HttpUtility.shared.getApiDataWithOtherToken(requestUrl: url!, resultType: FrindRequest.self) { (result) in
            guard let result = result else {
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(result))
        }
    }
    
    func getSentRequests(completion: @escaping(Result<FrindRequest, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "sent/requests")
        HttpUtility.shared.getApiData(requestUrl: url!, resultType: FrindRequest.self) { (result, done) in
            if done{
                guard let result = result else {
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


struct FrindRequest: Codable {
    let success     : Bool?
    let message     : String?
    let next_offset : Int?
    let users       : [CommunityUser]?

    enum CodingKeys: String, CodingKey {

        case success        = "success"
        case message        = "message"
        case next_offset    = "next_offset"
        case users          = "friends"
    }

    init(from decoder: Decoder) throws {
        let values      = try decoder.container(keyedBy: CodingKeys.self)
        success         = try values.decodeIfPresent(Bool.self, forKey: .success)
        message         = try values.decodeIfPresent(String.self, forKey: .message)
        next_offset     = try values.decodeIfPresent(Int.self, forKey: .next_offset)
        users           = try values.decodeIfPresent([CommunityUser].self, forKey: .users)
    }

}
