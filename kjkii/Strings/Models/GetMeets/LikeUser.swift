//
//  LikeUser.swift
//  kjkii
//
//  Created by Shahbaz on 14/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation

struct LikeUser: Codable {
    var id = Int()
    func likeUser(completion : @escaping(Result<LikeUserResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "like/user")!
        do {
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: LikeUserResponse.self) { (result) in
                guard let result = result else{
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
        }catch (let error){
            print("error while liking users \(error.localizedDescription)")
        }
    }
    
    
    func BlockUser(completion : @escaping(Result<LikeUserResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "block/user")!
        do {
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: LikeUserResponse.self) { (result) in
                guard let result = result else{
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
        }catch (let error){
            print("error while liking users \(error.localizedDescription)")
        }
    }
    
    
    func unfollow(completion : @escaping(Result<LikeUserResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "unfollow/user")!
        do {
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: LikeUserResponse.self) { (result) in
                guard let result = result else{
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
        }catch (let error){
            print("error while liking users \(error.localizedDescription)")
        }
    }
    
    
    
    
}




// MARK: - LikeUserResponse
struct LikeUserResponse: Codable {
    let success: Bool?
    let message: String?
    let user: CommunityUser?
}





struct DisLikeUser: Codable {
    var id = Int()
    func likeUser(completion : @escaping(Result<DisLikedUserResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "dislike/user")!
        do {
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: DisLikedUserResponse.self) { (result) in
                guard let result = result else{
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
        }catch (let error){
            print("error while liking users \(error.localizedDescription)")
        }
    }
}





struct DisLikedUserResponse: Codable {
    let success: Bool
    let message: String
}


struct FollowUser: Codable {
    var id = Int()
    func likeUser(completion : @escaping(Result<DisLikedUserResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "follow/user")!
        do {
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: DisLikedUserResponse.self) { (result) in
                guard let result = result else{
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
        }catch (let error){
            print("error while liking users \(error.localizedDescription)")
        }
    }
}

