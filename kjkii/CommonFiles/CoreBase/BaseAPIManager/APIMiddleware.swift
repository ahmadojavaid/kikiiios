//
//  APIMiddleware.swift
//  UniversityKorner
//
//  Created by Naveed on 7/31/18.
//  Copyright © 2018 Ali Bajwa. All rights reserved.
//

import Alamofire

class APIMiddleware: RequestAdapter {
   
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let user = User.current {
            let token = user.access_token
        
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
