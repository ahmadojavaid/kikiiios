//
//  HttpUtility.swift
//  MvvmDemoApp
//
//  Created by Codecat15 on 3/14/2020.
//  Copyright © 2020 Codecat15. All rights reserved.
//

import Foundation

struct HttpUtility
{
    init() { }
    static let shared = HttpUtility()
    func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T?, _ done: Bool)-> Void)
    {
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (responseData, httpUrlResponse, error) in
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(T.self, from: responseData!)
                        _=completionHandler(result, true)
                    }
                    catch let error{
                        debugPrint("error occured while decoding = \(error)")
                        completionHandler(nil, false)
                    }
                }
                
            }

        }.resume()
    }
    
    
    func getApiDataWithOtherToken<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
        var request = URLRequest(url: requestUrl)
        print(request.url?.absoluteString)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("Bearer \(CurrentUser.userData()!.auth_token!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (responseData, httpUrlResponse, error) in
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(T.self, from: responseData!)
                        _=completionHandler(result)
                    }
                    catch let error{
                        debugPrint("error occured while decoding = \(error)")
                    }
                }
                
            }

        }.resume()
    }

    func getApiDataString<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T?, _ done: Bool)-> Void)
    {
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (responseData, httpUrlResponse, error) in
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                print(String(data: responseData!, encoding: .utf8)!)
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(T.self, from: responseData!)
                        _=completionHandler(result, true)
                    }
                    catch let error{
                        debugPrint("error occured while decoding = \(error)")
                        _=completionHandler(nil, false)
                    }
                }
                
            }

        }.resume()
    }

    
    
    func postApiData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            DispatchQueue.main.async {
                if(error == nil && data != nil && data?.count != 0)
                {
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data!)
                        _=completionHandler(response)
                    }
                    catch let decodingError {
                        debugPrint(decodingError)
                    }
                }
            }
            

        }.resume()
    }
    
    func postApiDataWithAuth<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            DispatchQueue.main.async {
                if(error == nil && data != nil && data?.count != 0)
                {   
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data!)
                        _=completionHandler(response)
                    }
                    catch let decodingError {
                        debugPrint(decodingError)
                    }
                }
            }
            

        }.resume()
    }
    
    
    
    
    func postApiDataWithAuthString<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            DispatchQueue.main.async {
                if(error == nil && data != nil && data?.count != 0)
                {
                    print(String(data: data!, encoding: .utf8)!)
                    
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data!)
                        _=completionHandler(response)
                    }
                    catch let decodingError {
                        debugPrint(decodingError)
                    }
                }
            }
            

        }.resume()
    }
    
    
    func deleteApiCall<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (responseData, httpUrlResponse, error) in
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(T.self, from: responseData!)
                        _=completionHandler(result)
                    }
                    catch let error{
                        debugPrint("error occured while decoding = \(error)")
                    }
                }
                
            }

        }.resume()
    }

    
}


