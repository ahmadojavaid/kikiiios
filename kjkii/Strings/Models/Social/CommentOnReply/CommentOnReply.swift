//
//  CommentOnReply.swift
//  kjkii
//
//  Created by Shahbaz on 19/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct CommentOnReply : Codable {
    var comment_id  = String()
    var body        = String()
    func addComment(completion  : @escaping(Result<CommentReply, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "add/comment")
        do{
            let data = try JSONEncoder().encode(self)
            print("******* reply data")
            print(String(data: data, encoding: .utf8)!)
            
            HttpUtility.shared.postApiDataWithAuthString(requestUrl: url!, requestBody: data, resultType: CommentReply.self) { (result) in
                guard let result = result else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
        } catch (let error){
            print("Error while uploading reply on comment \(error.localizedDescription)")
        }
        
    }
    
}
