//
//  PostNewComment.swift
//  kikii
//
//  Created by Shahbaz on 16/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct PostNewComment: Codable {
    var post_id = String()
    var body = String()
    func postComment(completion: @escaping(Result<CommentPostedResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "add/comment")!
        do{
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: CommentPostedResponse.self) { (result) in
                guard let result = result else{
                    completion(.failure(.inValidUserName))
                    return
                }
                completion(.success(result))
            }
            
        } catch (let error){
            print("Please Try later \(error.localizedDescription)")
        }
    }
    
}


struct CommentPostedResponse: Codable {
    var success : Bool
    var message : String
    var comment : Comments
}





