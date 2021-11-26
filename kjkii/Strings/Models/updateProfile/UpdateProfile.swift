//
//  UpdateProfile.swift
//  kjkii
//
//  Created by Shahbaz on 13/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct UpdateProfile: Codable {
    var name        = String()
    var email       = String()
    var birthday    = String()
    func updateProfile(completion: @escaping(Result<PhoneNumberResponse, ErrorMessage>)->Void){
        if name.isEmpty{
            completion(.failure(.enterName))
            return
        } else if !email.isValidEmail(){
            completion(.failure(.invalidEmail))
            return
        } else if birthday.isEmpty{
            completion(.failure(.birthday))
            return
        } else {
            let url = URL(string: EndPoints.BASE_URL + "update/profile")!
            do{
                let data = try JSONEncoder().encode(self)
                HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: PhoneNumberResponse.self) { (result) in
                    guard let result = result else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    completion(.success(result))
                }
            } catch (let error) {
                print("Error please later \(error.localizedDescription)")
            }
        }
    }
    
}
