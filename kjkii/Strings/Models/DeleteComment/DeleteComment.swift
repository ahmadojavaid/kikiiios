//
//  DeleteComment.swift
//  kjkii
//
//  Created by Shahbaz on 21/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct DeleteComment {
    var id = String()
    func delete(completion: @escaping(_ done: Bool)->Void){
        let url = URL(string: EndPoints.BASE_URL  + "delete/comment/\(id)")!
        HttpUtility.shared.deleteApiCall(requestUrl: url, resultType: PostLiked.self) { (result) in
            guard let _ = result else{
                completion(false)
                return
            }
            completion(true)
        }
        
    }
}
