//
//  APIManagerBase.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias APIResponseClousure = (_ status: APIResponseStatus, _ response: Data?) -> Void

class BaseManager:NSObject {
    
    var headers: HTTPHeaders {
        //Reachability.forInternetConnection()
        return ["Content-Type": "application/json"]
    }
    var headersAJSON: HTTPHeaders {
        return ["Accept": "application/json"]
    }
    var headersACJSON: HTTPHeaders {
        return ["Content-Type": "application/json",
                      "Accept": "application/json"]
    }
    var headersACJSONAuth: HTTPHeaders {
        return ["Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization":"Bearer \(User.current?.access_token ?? "")"]
    }
    
    var isNetworkReachable: Bool {
        guard let reachability = Reachability.forInternetConnection() else { return true }
        return reachability.isReachable()
    }
    var sessionManager: SessionManager
    var user: User?
    var basePath: String
    
    
    override init() {
        sessionManager = Alamofire.SessionManager.default
        sessionManager.adapter = APIMiddleware()
        self.user = nil
        basePath = Constants.baseURL + "/api" // UserLogin().baseURL
    }
}

extension BaseManager {
    /// HTTP GET type request
    func getRequestWithAuth(_ endPoint: String, completion: @escaping APIResponseClousure) {
        let urlString = basePath + endPoint
        guard let url = URL(string: urlString) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }
        
        sessionManager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (response) in
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            let status = APIResponseStatus(isSuccess: true, code: 200, message: "")
            return completion(status, value)
        }
    }
    
    func postRequestWithAuth(_ endPoint: String, parameters:[String:Any]? = nil, completion: @escaping APIResponseClousure) {
        let urlString = basePath + endPoint
        guard let url = URL(string: urlString) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }
        
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).response { (response) in
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            let status = APIResponseStatus(isSuccess: true, code: 200, message: "")
            return completion(status, value)
        }
    }
    
    
    func getRequest(_ endPoint: String, parms:[String:Any]?, header:HTTPHeaders?, completion: @escaping APIResponseClousure) {
        let urlString = basePath + endPoint
        print("urlString: \(urlString)")
        guard let url = URL(string: urlString) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }
        
        Alamofire.request(url, method: .get, parameters: parms, encoding: JSONEncoding.default, headers: header).response { (response) in
            //print("Response: \(String(data: response.data ?? Data(), encoding: .utf8))")
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            return completion(APIResponseStatus.success, value)
        }
    }
    
    func postRequest(_ method: String, parms:[String:Any]?, header:HTTPHeaders?, completion: @escaping APIResponseClousure) {
        let urlString = basePath + method
        print("urlString: \(urlString)")
        guard let url = URL(string: urlString) else {
            return completion(APIResponseStatus.invalidRequest, nil)
        }
        print(url)
        if !isNetworkReachable {
            return completion(APIResponseStatus.noNetwork, nil)
        }

        Alamofire.request(url, method: .post, parameters: parms, encoding: JSONEncoding.default, headers: header ?? headersACJSON).response { (response) in
            
            //guard let data = response.data else { return }
            //print("Error: \(response.error?.localizedDescription)")
            //print("Response Data:" + (String(data: data, encoding: .utf8) ?? ""))
            if response.error != nil {
                let status = APIResponseStatus(isSuccess: false,
                                               code: response.response?.statusCode ?? 404,
                                               message: response.error!.localizedDescription
                )
                return completion(status, nil)
            }
            
            guard let value = response.data else {
                return completion(APIResponseStatus.unknown, nil)
            }
            let status = APIResponseStatus(isSuccess: true, code: 200, message: "")
            return completion(status, value)
        }
    }
    
    func processValidationMessages(dataMsgs:JSON) -> String {
        let messages = Array(dataMsgs.dictionaryValue.values).map { (json) -> String in
            let msg = json.arrayValue[0].stringValue
            return msg
        }
        var message = ""
        messages.forEach { (msg) in
            message = message + (message.count > 1 ? "\n":"") + msg
        }
        return message
    }
}
