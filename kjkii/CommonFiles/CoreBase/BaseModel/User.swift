//
//  User.swift
//  UniversityKorner
//
//  Created by Naveed on 7/31/18.
//  Copyright © 2018 Ali Bajwa. All rights reserved.
//

import UIKit
import SwiftyJSON
//import ObjectMapper

class User:NSObject, NSCoding, Codable {
    var access_token: String = ""  //"",
    var id: Int = 0  // 715,
    var email: String = ""  // "mohsin111@gmail.com",
    var name: String = ""  // "Mohsin Baig12376",
    var student_id: String = ""
    var profile_image: String = ""  // "/img/82181624-.png",
    var smester_id: String = ""  // 1,
    var smester_name: String = ""  // "smester 1",
    
    var email_verified_at = ""
        
    static var isLogedIn: Bool {
        return UserDefaults.standard.bool(forKey: "isLogedIn")
    }
    static func setLogedIn() {
        UserDefaults.standard.set(true, forKey: "isLogedIn")
    }
    static func setLogedOut() {
        UserDefaults.standard.set(false, forKey: "isLogedIn")
    }
    
    override init() {
        super.init()
    }
    
    init(json:JSON) {
        access_token = json["token"].stringValue   //    "es",
        
        var details = json["userDetails"]
        if details.dictionary == nil {
            details = json["user"]
        }
        
        id = details["id"].intValue  // 715,
        email = details["email"].stringValue  //
        name = details["name"].stringValue  //
        profile_image = Constants.baseURL + details["avatar"].stringValue  //
        
        let semester = details["smester"]
        if semester.dictionary == nil {
            student_id = details["student_detail"]["student_id"].stringValue
            smester_id = details["student_detail"]["smester"]["id"].stringValue
            smester_name = details["student_detail"]["smester"]["smester_name"].stringValue
        } else {
            smester_id = semester["id"].stringValue  // 1,
            smester_name = semester["smester_name"].stringValue
        }
        if student_id == "" {
            student_id = json["userDetails"]["studentID"].stringValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) { // to retrive data stored at secondary storage
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String ?? ""
        id = aDecoder.decodeObject(forKey: "id") as? Int ?? 0
        email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        profile_image = aDecoder.decodeObject(forKey: "profile_image") as? String ?? ""
        smester_id = aDecoder.decodeObject(forKey: "smester_id") as? String ?? ""
        smester_name = aDecoder.decodeObject(forKey: "smester_name") as? String ?? ""
        student_id = aDecoder.decodeObject(forKey: "student_id") as? String ?? ""
    }
    
    public func encode(with aCoder: NSCoder) { // to store data at secondary storage
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(profile_image, forKey: "profile_image")
        aCoder.encode(smester_id, forKey: "smester_id")
        aCoder.encode(smester_name, forKey: "smester_name")
        aCoder.encode(student_id, forKey: "student_id")
    }
    
    class var current: User? {
        var user: User?
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("data")
        //print("fullPath : \(fullPath)")
        do {
            //user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User
            let data = try Data(contentsOf: fullPath)
            user = try NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: data)
            return user
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func save() {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("data")
        //print("fullPath : \(fullPath)")
        do {
            //let data = NSKeyedArchiver.archivedData(withRootObject: self)
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            try data.write(to: fullPath, options: .atomic)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func clear() {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("data")
        try? fileManager.removeItem(at: fullPath)
    }
    
    func updateDetails(json:JSON) {
        name = json["user"]["name"].stringValue
        email = json["user"]["email"].stringValue
        profile_image = Constants.baseURL + json["user"]["avatar"].stringValue
        student_id = json["user"]["student_detail"]["student_id"].stringValue
    }
}

