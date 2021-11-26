//
//  EditProfileAttr.swift
//  kjkii
//
//  Created by Shahbaz on 06/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
import ProgressHUD

struct EditProfileAttr {
    var item = String()
    func getItems(completion: @escaping(Result<Value, ErrorMessage>)->Void){
        ProgressHUD.show()
        let url = URL(string: EndPoints.BASE_URL + "get/category/\(item)")!
        print(url.absoluteString)
        HttpUtility.shared.getApiData(requestUrl: url, resultType: EditProfileItems.self) { (result, done) in
            ProgressHUD.dismiss()
            if done{
                guard let result = result?.value else{
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


struct EditProfileItems : Codable {
    let success : Bool?
    let message : String?
    let value : Value?
    let isChecked : String?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case value = "value"
        case isChecked = "IsChecked"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        value = try values.decodeIfPresent(Value.self, forKey: .value)
        isChecked = try values.decodeIfPresent(String.self, forKey: .isChecked)
    }
}

struct Value : Codable {
    let id : Int?
    let key : String?
    let value : [String]?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case key = "key"
        case value = "value"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        value = try values.decodeIfPresent([String].self, forKey: .value)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}


extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

