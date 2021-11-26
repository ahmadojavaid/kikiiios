//
//  FiltersModel.swift
//  kjkii
//
//  Created by Mazhar on 2021-03-02.
//  Copyright © 2021 abbas. All rights reserved.
//

import Foundation
struct AvailableFilters: Codable{

    var success: Bool
    var filters: [AllFilters]
    var selected: Bool?
   
    
}
struct AllFilters: Codable{
    var id: Int
    var key: String
    var value: [String]
    var created_at: String
    var updated_at: String
    var selected: Bool?
    
}
struct FetchSelectedFilters: Codable{
    var success: Bool
    var message: String
    var filters: SelectedFilters?
   
    
}

struct SelectedFilters: Codable{
    var id: Int
    var distance: String?
    var distance_in: String?
    var height: String?
    var gender_identity: String?
    var sexual_identity : String?
    var pronouns: String?
    var relationship_status : String?
    var diet_like: String?
    var sign: String?
    var looking_for: String?
    var drink: String?
    var cannabis: String?
    var political_views: String?
    var religion: String?
    var pets: String?
    var kids: String?
    var smoke: String?
    var last_online: String?
    var user_id: Int?
    var created_at: String?
    var updated_at: String?
    var from_age: String?
    var to_age: String?
    
}


