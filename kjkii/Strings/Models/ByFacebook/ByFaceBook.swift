//
//  ByFaceBook.swift
//  kjkii
//
//  Created by Shahbaz on 12/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct RegisterWithFaceBook : Encodable {
    var uid         = String()
    var email       = String()
    var name        = String()
    var birthday    = String()
    func register(completion : @escaping(Result<PhoneNumberResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "continue/with-facebook")!
        do{
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiData(requestUrl: url, requestBody: data, resultType: PhoneNumberResponse.self) { (result) in
                guard let result = result else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
        }
        catch (let error)
        {
            print("Here are error \(error.localizedDescription)")
        }
        
    }
}
