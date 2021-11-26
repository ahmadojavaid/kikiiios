//
//  Web_calls.swift
//  Link_Chinot
//
//  Created by macbook on 23/07/2019.
//  Copyright © 2019 macbook. All rights reserved.
//




import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import ProgressHUD

let appColor = UIColor(named: "appRed")!
let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
let BASE_URL = EndPoints.BASE_URL

let DEFAULTS = UserDefaults.standard
let API_ERROR = "Error accured at server side, please try later"
let NO_INTERNET = "Please Connect to internet to be updated with most lastest data"
var one = JSON()


var upperView = UIView()

func postWebCall(url:String, params: Parameters, webCallName: String, sender:UIViewController,completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    
    if Reach.isConnectedToNetwork()
    {
        ProgressHUD.show()
        
        //        let upperView = UIView(frame: sender.view.frame)
        //        upperView.backgroundColor = appColor.withAlphaComponent(0.0)
        //        let loading = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: appColor, padding: 0)
        //        loading.translatesAutoresizingMaskIntoConstraints = false
        //        upperView.addSubview(loading)
        //        NSLayoutConstraint.activate([
        //            loading.widthAnchor.constraint(equalToConstant: 40),
        //            loading.heightAnchor.constraint(equalToConstant: 40),
        //            loading.centerYAnchor.constraint(equalTo: upperView.centerYAnchor),
        //            loading.centerXAnchor.constraint(equalTo: upperView.centerXAnchor)
        //        ])
        //        loading.startAnimating()
        //        sender.view.addSubview(upperView)
        let baseurl = URL(string:url)!
        print(webCallName)
        print(url)
        print(params)
        Alamofire.request(baseurl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{ (responseData) -> Void in
            if((responseData.error) == nil)
            {
                //                loading.stopAnimating()
                //                upperView.isHidden = true
                ProgressHUD.dismiss()
                let a = JSON(responseData.value)
                completionHandler(a, false)
                print(a)
            }
            else
            {
                let a = JSON()
                //loading.stopAnimating()
                upperView.isHidden = true
                //loading.stopAnimating()
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
    }
    else
    {
        //
    }
}

func getFiltersData(url: URL,onSuccess : @escaping (Bool, String, AnyObject) -> Void, onFailure : @escaping (Bool, String, AnyObject) -> Void) {
            

          
            
    Alamofire.request(url, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { (response) in
           
//            print(response.result.value)
                switch response.result {
                case .success:
                   onSuccess(true, response.result.description, response.result.value as AnyObject)
                    print(response.result.value)
                case .failure(let error):
                    print(error)
                    onFailure(false, response.error?.localizedDescription ?? "Something went wrong.", response.error as AnyObject)
                }
            }
            
        }
func getSinglePostData(param: Parameters,url: URL,onSuccess : @escaping (Bool, String, AnyObject) -> Void, onFailure : @escaping (Bool, String, AnyObject) -> Void) {
            

          
            
    Alamofire.request(url, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { (response) in
           
//            print(response.result.value)
                switch response.result {
                case .success:
                    onSuccess(true, response.result.description, response.result.value as AnyObject)
                    print(response.result.value)
                case .failure(let error):
                    print(error)
                    onFailure(false, response.error?.localizedDescription ?? "Something went wrong.", response.error as AnyObject)
                }
            }
            
        }


func postWebCall(url:String, params: Parameters, webCallName: String, completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    
    if Reach.isConnectedToNetwork()
    {
        ProgressHUD.show()
        let baseurl = URL(string:url)!
        print(webCallName)
        print(url)
        print(params)
        Alamofire.request(baseurl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{ (responseData) -> Void in
            if((responseData.error) == nil)
            {
                //                loading.stopAnimating()
                //                upperView.isHidden = true
                ProgressHUD.dismiss()
                let a = JSON(responseData.value)
                completionHandler(a, false)
                print(a)
            }
            else
            {
                let a = JSON()
                //loading.stopAnimating()
                upperView.isHidden = true
                //loading.stopAnimating()
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
    }
    else
    {
        //
    }
}



func webCallWithImageWithName(url:String, parameters: Parameters, webCallName: String, imgData:Data,imageName: String, completionHandler: @escaping ( _ done :Bool)->Void)
{
    print(url)
    print(parameters)
    
    let boundary = "Boundary-\(UUID().uuidString)"
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    Alamofire.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: imageName,fileName: "\(imageName).png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        },
        with: request,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    print("uploding\(progress)")
                    let total = progress.totalUnitCount
                    let obt  = progress.completedUnitCount
                    let per = Double(obt) / Double(total) * 100
                    let _ = Int(per)
                }
                upload.responseString { response in
                    let a = response.value!
                    let data = a.data(using: .utf8)
                    do{
                        let result = try JSONDecoder().decode(PhoneNumberResponse.self, from: data!)
                        UIHelper.shared.saveUserData(user: result.user!)
                        if result.success ?? false{
                            completionHandler(true)
                        }
                        else{
                            completionHandler(false)
                        }
                        
                    }catch (let err)  {
                        print("With tht \(err.localizedDescription)")
                    }
                    //                    switch response.result {
                    //                    case .failure(let error) :
                    //                        let message : String
                    //                        if let httpStatusCode = response.response?.statusCode {
                    //                            switch(httpStatusCode) {
                    //                            case 404:
                    //                                message = "File not found"
                    //                            case 500 :
                    //                                message = "Internal Error"
                    //                            default:
                    //                                message = "Connection issue, please make sure you have a good internet access, or please contact IT Support."
                    //                            }
                    //                        } else {
                    //                            message = error.localizedDescription
                    //                        }
                    //
                    //                    case .success( let response) :
                    //                        let json = JSON(response)
                    //                        completionHandler(json, false)
                    //                    }
                }
            case .failure(let encodingError):
                let _ = encodingError.localizedDescription
                print(encodingError)
                completionHandler(false)
                break
            }
        }
    )
    
    
    
    //    Alamofire.upload(multipartFormData: { multipartFormData in
    //        multipartFormData.append(imgData, withName: imageName,fileName: "image.png", mimeType: "image/png")
    //        for (key, value) in parameters
    //        {
    //            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
    //        }
    //    },to:url)
    //    { (result) in
    //        switch result {
    //        case .success(let upload, _, _):
    //            upload.uploadProgress(closure: { (progress) in
    //                print("Upload Progress: \(progress.fractionCompleted)")
    //                print("uploding\(progress)")
    //                let total = progress.totalUnitCount
    //                let obt  = progress.completedUnitCount
    //                let per = Double(obt) / Double(total) * 100
    //                let _ = Int(per)
    //
    //
    //            })
    //            upload.responseJSON { response in
    //
    //                print("done")
    //                let a = JSON(response.result.value)
    //                print(a)
    //                completionHandler(a, false)
    //
    //            }
    //        case .failure(let encodingError):
    //            print(encodingError)
    //            let a = JSON()
    //            completionHandler(a, true)
    //        }
    //    }
    
}

func getWebCallWithTokenWithCodeAble(url:String, params: Parameters, webCallName: String,sender: UIViewController, completionHandler: @escaping (_ res:String, _ error: Bool)->Void)
{
    
    //let urrl = url.replacingOccurrences(of: " ", with: "%20")
    let baseurl = URL(string:url.replacingOccurrences(of: " ", with: "%20"))!
    
    Alamofire.request(baseurl, method: .get, parameters: params, encoding: URLEncoding.default,headers: headers).responseString{ (responseData) -> Void in
        
        
        if((responseData.result.value) != nil)
        {
            
            let a = "\(responseData.value!)" //JSON(responseData.result.value)
            completionHandler(a, false)
            
        }
        else
        {
            let a = ""
            
            completionHandler(a, true)
            
        }
    }// Alamofire ends here
    
    
}
func getWebCallWithOutTokenWithCodeAble(url:String, params: Parameters, webCallName: String,sender: UIViewController, completionHandler: @escaping (_ res:String, _ error: Bool)->Void)
{
    
    //let urrl = url.replacingOccurrences(of: " ", with: "%20")
    let baseurl = URL(string:url.replacingOccurrences(of: " ", with: "%20"))!
    
    Alamofire.request(baseurl, method: .get, parameters: params, encoding: URLEncoding.default).responseString{ (responseData) -> Void in
        
        
        if((responseData.result.value) != nil)
        {
            
            let a = "\(responseData.value!)" //JSON(responseData.result.value)
            completionHandler(a, false)
            
        }
        else
        {
            let a = ""
            
            completionHandler(a, true)
            
        }
    }// Alamofire ends here
    
    
}




func webCallWithImageArray(url:String, parameters: Parameters, webCallName: String, imgData:[Data], completionHandler: @escaping ( _ done :Bool)->Void)
{
   
    let boundary = "Boundary-\(UUID().uuidString)"
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    let pp = ["body":"headd coded"]
    Alamofire.upload(
        multipartFormData: { multipartFormData in
            for data in imgData{
                multipartFormData.append(data, withName: "new_pics",fileName: "new_pics.png", mimeType: "image/png")
            }
            
            for (key, value) in pp {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
            }
            
        },
        to: url, headers: headers,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value)
                        print(json)
                        
                        break
                    case .failure(let error):
                        
                        break
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    )
    
    
    ///_____________________________________
    
    
    
    
    
    
    //    Alamofire.upload(
    //        multipartFormData: { multipartFormData in
    //            for data in imgData{
    //                multipartFormData.append(data, withName: "new_pics",fileName: "new_pics.png", mimeType: "image/png")
    //            }
    //
    //            for (key, value) in parameters {
    //                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
    //            }
    //        },
    //        with: request,
    //        encodingCompletion: { encodingResult in
    //            switch encodingResult {
    //            case .success(let upload, _, _):
    //                upload.uploadProgress { (progress) in
    //                    print("Upload Progress: \(progress.fractionCompleted)")
    //                    print("uploding\(progress)")
    //                    let total = progress.totalUnitCount
    //                    let obt  = progress.completedUnitCount
    //                    let per = Double(obt) / Double(total) * 100
    //                    let _ = Int(per)
    //                }
    //                upload.responseString { response in
    //                    let a = response.value!
    //                    print(a)
    //                    let data = a.data(using: .utf8)
    //                    do{
    //                        let result = try JSONDecoder().decode(PhoneNumberResponse.self, from: data!)
    //                        UIHelper.shared.saveUserData(user: result.user!)
    //                        if result.success ?? false{
    //                            completionHandler(true)
    //                        }
    //                        else{
    //                            completionHandler(false)
    //                        }
    //
    //                    }catch (let err)  {
    //                        print("With tht \(err.localizedDescription)")
    //                    }
    //                    //                    switch response.result {
    //                    //                    case .failure(let error) :
    //                    //                        let message : String
    //                    //                        if let httpStatusCode = response.response?.statusCode {
    //                    //                            switch(httpStatusCode) {
    //                    //                            case 404:
    //                    //                                message = "File not found"
    //                    //                            case 500 :
    //                    //                                message = "Internal Error"
    //                    //                            default:
    //                    //                                message = "Connection issue, please make sure you have a good internet access, or please contact IT Support."
    //                    //                            }
    //                    //                        } else {
    //                    //                            message = error.localizedDescription
    //                    //                        }
    //                    //
    //                    //                    case .success( let response) :
    //                    //                        let json = JSON(response)
    //                    //                        completionHandler(json, false)
    //                    //                    }
    //                }
    //            case .failure(let encodingError):
    //                let _ = encodingError.localizedDescription
    //                print(encodingError)
    //                completionHandler(false)
    //                break
    //            }
    //        }
    //    )
    
    
    
    //    Alamofire.upload(multipartFormData: { multipartFormData in
    //        multipartFormData.append(imgData, withName: imageName,fileName: "image.png", mimeType: "image/png")
    //        for (key, value) in parameters
    //        {
    //            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
    //        }
    //    },to:url)
    //    { (result) in
    //        switch result {
    //        case .success(let upload, _, _):
    //            upload.uploadProgress(closure: { (progress) in
    //                print("Upload Progress: \(progress.fractionCompleted)")
    //                print("uploding\(progress)")
    //                let total = progress.totalUnitCount
    //                let obt  = progress.completedUnitCount
    //                let per = Double(obt) / Double(total) * 100
    //                let _ = Int(per)
    //
    //
    //            })
    //            upload.responseJSON { response in
    //
    //                print("done")
    //                let a = JSON(response.result.value)
    //                print(a)
    //                completionHandler(a, false)
    //
    //            }
    //        case .failure(let encodingError):
    //            print(encodingError)
    //            let a = JSON()
    //            completionHandler(a, true)
    //        }
    //    }
    
}


func createPostWithImages(url:String, parameters: Parameters, webCallName: String, imgData:[Data], completionHandler: @escaping ( _ done :Bool)->Void)
{
    print(url)
    print(parameters)
    
    //    let boundary = "Boundary-\(UUID().uuidString)"
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = "POST"
    Alamofire.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append("This ishte  headr".data(using: .utf8)!, withName: "body")
            for data in imgData{
                multipartFormData.append(data, withName: "media[]",fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/png")
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                
                
            }
        },
        with: request,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    print("uploding\(progress)")
                    let total = progress.totalUnitCount
                    let obt  = progress.completedUnitCount
                    let per = Double(obt) / Double(total) * 100
                    let _ = Int(per)
                }
                upload.responseString { response in
                    let a = response.value!
                    
                    print(response)
                    completionHandler(true)
                    //                    let data = a.data(using: .utf8)
                    //                    do{
                    //                        let result = try JSONDecoder().decode(PhoneNumberResponse.self, from: data!)
                    //                        UIHelper.shared.saveUserData(user: result.user!)
                    //                        if result.success ?? false{
                    //                            completionHandler(true)
                    //                        }
                    //                        else{
                    //                            completionHandler(false)
                    //                        }
                    //
                    //                    }catch (let err)  {
                    //                        print("With tht \(err.localizedDescription)")
                    //                    }
                    //                    switch response.result {
                    //                    case .failure(let error) :
                    //                        let message : String
                    //                        if let httpStatusCode = response.response?.statusCode {
                    //                            switch(httpStatusCode) {
                    //                            case 404:
                    //                                message = "File not found"
                    //                            case 500 :
                    //                                message = "Internal Error"
                    //                            default:
                    //                                message = "Connection issue, please make sure you have a good internet access, or please contact IT Support."
                    //                            }
                    //                        } else {
                    //                            message = error.localizedDescription
                    //                        }
                    //
                    //                    case .success( let response) :
                    //                        let json = JSON(response)
                    //                        completionHandler(json, false)
                    //                    }
                }
            case .failure(let encodingError):
                let _ = encodingError.localizedDescription
                print(encodingError)
                completionHandler(false)
                break
            }
        }
    )
    
    
    
    //    Alamofire.upload(multipartFormData: { multipartFormData in
    //        multipartFormData.append(imgData, withName: imageName,fileName: "image.png", mimeType: "image/png")
    //        for (key, value) in parameters
    //        {
    //            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
    //        }
    //    },to:url)
    //    { (result) in
    //        switch result {
    //        case .success(let upload, _, _):
    //            upload.uploadProgress(closure: { (progress) in
    //                print("Upload Progress: \(progress.fractionCompleted)")
    //                print("uploding\(progress)")
    //                let total = progress.totalUnitCount
    //                let obt  = progress.completedUnitCount
    //                let per = Double(obt) / Double(total) * 100
    //                let _ = Int(per)
    //
    //
    //            })
    //            upload.responseJSON { response in
    //
    //                print("done")
    //                let a = JSON(response.result.value)
    //                print(a)
    //                completionHandler(a, false)
    //
    //            }
    //        case .failure(let encodingError):
    //            print(encodingError)
    //            let a = JSON()
    //            completionHandler(a, true)
    //        }
    //    }
    
}
func  webCallForMultipleImages(url:String,parameters: Parameters,webCallName:String,imgDate:[Data],imageName: String,comefromEditProfile:Bool,mainProfileImgData:[Data], sender:
                                UIViewController,completionHandler: @escaping (_ res:JSON, _ error:Bool)->Void)
{
//    Alamofire.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
//
    Alamofire.upload(multipartFormData: { multipartFormData in
        let count = imgDate.count
        for (key, value) in parameters {
    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!, withName: key)


               }
        
      for i in 0..<count{
            multipartFormData.append(imgDate[i], withName: imageName + "[\(i)]", fileName: "photo\(i).jpeg" , mimeType: "image/jpeg")

        }
        if comefromEditProfile{
            if mainProfileImgData.count != 0{
            multipartFormData.append(mainProfileImgData[0], withName: "profile_pic", fileName: "photo.jpeg" , mimeType: "image/jpeg")
            }
        }
        
      //  for (key, value) in parameters {
//        multipartFormData.append("".data(using: .utf8)!, withName: "gender_identity")
       // }
       
        
    },to:url,method: .post, headers: headers) { (result) in
        switch result {
        
        case .success(let upload, _ , _):
            
            upload.uploadProgress(closure: { (progress) in
                
                let total = progress.totalUnitCount
                let obt  = progress.completedUnitCount
                let per = Double(obt) / Double(total) * 100
                let perint = Int(per)
                //showProgress(text: "\(perint)" + " " + "%")
                //KRProgressHUD.showMessage("\(per)")
                
            })
            
            upload.responseJSON { response in
                //dismissProgress()
                //KRProgressHUD.dismiss()
                let resp = JSON(response.result.value)
            completionHandler(resp , false)
                
                
            }
            
        case .failure(let encodingError):
            let a = JSON()
            completionHandler(a, true)
            
        }
    }
    
}

func  webCallForSingleImages(url:String,parameters: Parameters,webCallName:String,imgDate:Data,imageName: String, sender:
                                UIViewController,completionHandler: @escaping (_ res:JSON, _ error:Bool)->Void)
{
//    Alamofire.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
//
    Alamofire.upload(multipartFormData: { multipartFormData in
        
        for (key, value) in parameters {
    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!, withName: key)


               }
        
     
            multipartFormData.append(imgDate, withName: imageName + "imageFor", fileName: "photo.jpeg" , mimeType: "image/jpeg")

      
        
      //  for (key, value) in parameters {
//        multipartFormData.append("".data(using: .utf8)!, withName: "gender_identity")
       // }
       
        
    },to:url,method: .post, headers: headers) { (result) in
        switch result {
        
        case .success(let upload, _ , _):
            
            upload.uploadProgress(closure: { (progress) in
                
                let total = progress.totalUnitCount
                let obt  = progress.completedUnitCount
                let per = Double(obt) / Double(total) * 100
                let perint = Int(per)
                //showProgress(text: "\(perint)" + " " + "%")
                //KRProgressHUD.showMessage("\(per)")
                
            })
            
            upload.responseJSON { response in
                //dismissProgress()
                //KRProgressHUD.dismiss()
                let resp = JSON(response.result.value)
            completionHandler(resp , false)
                
                
            }
            
        case .failure(let encodingError):
            let a = JSON()
            completionHandler(a, true)
            
        }
    }
    
}


func formDataWebCall(url:String, parameters: Parameters, webCallName: String, completionHandler: @escaping ( _ done :Bool)->Void)
{
    print(url)
    print(parameters)
    
    let boundary = "Boundary-\(UUID().uuidString)"
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue("Bearer \(CurrentUser.userData()!.auth_token ?? "")", forHTTPHeaderField: "Authorization")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    Alamofire.upload(
        multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        },
        with: request,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    print("uploding\(progress)")
                    let total = progress.totalUnitCount
                    let obt  = progress.completedUnitCount
                    let per = Double(obt) / Double(total) * 100
                    let _ = Int(per)
                }
                upload.responseString { response in
                    let a = response.value!
                    print(a)
                    completionHandler(true)
                    //                    let data = a.data(using: .utf8)
                    //                    do{
                    //                        let result = try JSONDecoder().decode(PhoneNumberResponse.self, from: data!)
                    //                        UIHelper.shared.saveUserData(user: result.user!)
                    //                        if result.success ?? false{
                    //                            completionHandler(true)
                    //                        }
                    //                        else{
                    //                            completionHandler(false)
                    //                        }
                    //
                    //                    }catch (let err)  {
                    //                        print("With tht \(err.localizedDescription)")
                    //                    }
                    //                    switch response.result {
                    //                    case .failure(let error) :
                    //                        let message : String
                    //                        if let httpStatusCode = response.response?.statusCode {
                    //                            switch(httpStatusCode) {
                    //                            case 404:
                    //                                message = "File not found"
                    //                            case 500 :
                    //                                message = "Internal Error"
                    //                            default:
                    //                                message = "Connection issue, please make sure you have a good internet access, or please contact IT Support."
                    //                            }
                    //                        } else {
                    //                            message = error.localizedDescription
                    //                        }
                    //
                    //                    case .success( let response) :
                    //                        let json = JSON(response)
                    //                        completionHandler(json, false)
                    //                    }
                }
            case .failure(let encodingError):
                let _ = encodingError.localizedDescription
                print(encodingError)
                completionHandler(false)
                break
            }
        }
    )
    
    
    
    //    Alamofire.upload(multipartFormData: { multipartFormData in
    //        multipartFormData.append(imgData, withName: imageName,fileName: "image.png", mimeType: "image/png")
    //        for (key, value) in parameters
    //        {
    //            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
    //        }
    //    },to:url)
    //    { (result) in
    //        switch result {
    //        case .success(let upload, _, _):
    //            upload.uploadProgress(closure: { (progress) in
    //                print("Upload Progress: \(progress.fractionCompleted)")
    //                print("uploding\(progress)")
    //                let total = progress.totalUnitCount
    //                let obt  = progress.completedUnitCount
    //                let per = Double(obt) / Double(total) * 100
    //                let _ = Int(per)
    //
    //
    //            })
    //            upload.responseJSON { response in
    //
    //                print("done")
    //                let a = JSON(response.result.value)
    //                print(a)
    //                completionHandler(a, false)
    //
    //            }
    //        case .failure(let encodingError):
    //            print(encodingError)
    //            let a = JSON()
    //            completionHandler(a, true)
    //        }
    //    }
    
}






func tempCall(url:String, params: Parameters, webCallName: String, completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    
    if Reach.isConnectedToNetwork()
    {
        let baseurl = URL(string:url)!
        print(webCallName)
        print(url)
        print(params)
        Alamofire.request(baseurl, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            print("Reqest sent")
            if((responseData.error) == nil)
            {
                upperView.isHidden = true
                let a = JSON(responseData.value)
                completionHandler(a, false)
                print(a)
            }
            else
            {
                let a = JSON()
                upperView.isHidden = true
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
    }
    else
    {
        //
    }
}
func postWebCallWithOutToken(url:String, params: [String : String], webCallName: String, sender:UIViewController,completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    
    if Reach.isConnectedToNetwork()
    {
        let upperView = UIView(frame: sender.view.frame)
        upperView.backgroundColor = appColor.withAlphaComponent(0.00)
        let loading = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: appColor, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: upperView.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: upperView.centerXAnchor)
        ])
        loading.startAnimating()
        sender.view.addSubview(upperView)
        let baseurl = URL(string:url)!
        print(webCallName)
        print(url)
        print(params)
        Alamofire.request(baseurl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers2).responseJSON{ (responseData) -> Void in
            if((responseData.error) == nil)
            {
                loading.stopAnimating()
                upperView.isHidden = true
                let a = JSON(responseData.value)
                //                let success = "\(a["success"])"
                //                if success == "-2"
                //                {
                //                    gotoLoginAlert(msg: "\(a["message"])", sender: sender)
                //                }
                //                else
                //                {
                //
                //                }
                completionHandler(a, false)
                print(a)
            }
            else
            {
                let a = JSON()
                loading.stopAnimating()
                upperView.isHidden = true
                loading.stopAnimating()
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
    }
    else
    {
        
    }
}

func postWebCallWithOutTokenString(url:String, params: [String : String], webCallName: String, sender:UIViewController,completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    
    if Reach.isConnectedToNetwork()
    {
        let upperView = UIView(frame: sender.view.frame)
        upperView.backgroundColor = appColor.withAlphaComponent(0.00)
        let loading = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: appColor, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: upperView.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: upperView.centerXAnchor)
        ])
        loading.startAnimating()
        sender.view.addSubview(upperView)
        let baseurl = URL(string:url)!
        print(webCallName)
        print(url)
        print(params)
        Alamofire.request(baseurl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers2).responseString{ (responseData) -> Void in
            if((responseData.error) == nil)
            {
                loading.stopAnimating()
                upperView.isHidden = true
                let a = JSON(responseData.value)
                //                let success = "\(a["success"])"
                //                if success == "-2"
                //                {
                //                    gotoLoginAlert(msg: "\(a["message"])", sender: sender)
                //                }
                //                else
                //                {
                //
                //                }
                completionHandler(a, false)
                print(a)
            }
            else
            {
                let a = JSON()
                loading.stopAnimating()
                upperView.isHidden = true
                loading.stopAnimating()
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
    }
    else
    {
        
    }
}


func mapsAutoCompleteCall(url:String, params: [String : String], webCallName: String, sender:UIViewController,completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    if Reach.isConnectedToNetwork()
    {
        
        let baseurl = URL(string:url.replacingOccurrences(of: " ", with: "%20"))!
        Alamofire.request(baseurl, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
            if((responseData.error) == nil)
            {
                
                let a = JSON(responseData.value)
                completionHandler(a, false)
                print(a)
            }
            else
            {
                let a = JSON()
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
        
    }
    else
    {
        
    }
    
}



func postWebCallString(url:String, params: Parameters, webCallName: String, sender: UIViewController, completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    
    if Reach.isConnectedToNetwork()
    {
        
        let upperView = UIView(frame: sender.view.frame)
        upperView.backgroundColor = appColor.withAlphaComponent(0.0)
        
        
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: appColor, padding: 0)
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        upperView.addSubview(loading)
        
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: upperView.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: upperView.centerXAnchor)
        ])
        
        loading.startAnimating()
        
        
        sender.view.addSubview(upperView)
        let baseurl = URL(string:url)!
        
        print(webCallName)
        print(url)
        print(params)
        Alamofire.request(baseurl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString{ (responseData) -> Void in
            
            print(responseData)
            
            if((responseData.error) == nil)
            {
                loading.stopAnimating()
                
                let a = JSON(responseData.value)
                //                let success = "\(a["success"])"
                //                if success == "-2"
                //                {
                //                    gotoLoginAlert(msg: "\(a["message"])", sender: sender)
                //                }
                //                else
                //                {
                //
                //                }
                completionHandler(a, false)
                
                upperView.isHidden = true
                print(a)
            }
            else
            {
                loading.stopAnimating()
                let a = JSON()
                loading.stopAnimating()
                upperView.isHidden = true
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
    }
    else
    {
        
    }
    
}



func getWebCall(url:String, params: Parameters, webCallName: String, sender: UIViewController, completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    if Reach.isConnectedToNetwork()
    {
        ProgressHUD.show()
        //        let upperView = UIView(frame: sender.view.frame)
        //        upperView.backgroundColor = appColor.withAlphaComponent(0.0)
        //        let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: appColor, padding: 0)
        //
        //        loading.translatesAutoresizingMaskIntoConstraints = false
        //
        //        upperView.addSubview(loading)
        //
        //        NSLayoutConstraint.activate([
        //            loading.widthAnchor.constraint(equalToConstant: 40),
        //            loading.heightAnchor.constraint(equalToConstant: 40),
        //            loading.centerYAnchor.constraint(equalTo: upperView.centerYAnchor),
        //            loading.centerXAnchor.constraint(equalTo: upperView.centerXAnchor)
        //        ])
        //        loading.startAnimating()
        //        sender.view.addSubview(upperView)
        //
        //
        
        let baseurl = URL(string:url)!
        print(webCallName)
        print(url)
        print(params)
        Alamofire.request(baseurl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON{ (responseData) -> Void in
            ProgressHUD.dismiss()
            if((responseData.error) == nil)
            {
                //                loading.stopAnimating()
                //                upperView.isHidden = true
                let a = JSON(responseData.value)
                //                let success = "\(a["success"])"
                //                if success == "-2"
                //                {
                //                    gotoLoginAlert(msg: "\(a["message"])", sender: sender)
                //                }
                //                else
                //                {
                //
                //                }
                completionHandler(a, false)
                
                print(a)
            }
            else
            {
                let a = JSON()
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
    }
    else
    {
        
    }
}


func deleteWebCall(url:String, params: Parameters, webCallName: String, sender: UIViewController, completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
{
    if Reach.isConnectedToNetwork()
    {
        
        let upperView = UIView(frame: sender.view.frame)
        upperView.backgroundColor = appColor.withAlphaComponent(0.0)
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: appColor, padding: 0)
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        upperView.addSubview(loading)
        
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: upperView.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: upperView.centerXAnchor)
        ])
        loading.startAnimating()
        sender.view.addSubview(upperView)
        let baseurl = URL(string:url)!
        print(webCallName)
        print(url)
        print(params)
        Alamofire.request(baseurl, method: .delete, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON{ (responseData) -> Void in
            if((responseData.error) == nil)
            {
                loading.stopAnimating()
                upperView.isHidden = true
                let a = JSON(responseData.value)
                //                let success = "\(a["success"])"
                //                if success == "-2"
                //                {
                //                    gotoLoginAlert(msg: "\(a["message"])", sender: sender)
                //                }
                //                else
                //                {
                //
                //                }
                completionHandler(a, false)
                
                print(a)
            }
            else
            {
                let a = JSON()
                loading.stopAnimating()
                upperView.isHidden = true
                loading.stopAnimating()
                print("Error is \(String(describing: responseData.result))")
                completionHandler(a, true)
                
            }
        }// Alamofire ends here
        
    }
    else
    {
        
    }
}



func webCallForMultipleImagess(url:String,parameters: Parameters,webCallName:String,imgDate:[Data],imageName: String, sender:
                                UIViewController,completionHandler: @escaping (_ res:JSON, _ error:Bool)->Void)
{
    
    print(parameters)
    //NActivityIndicator(sender: sender)
    Alamofire.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
        let count = imgDate.count
        for i in 0..<count{
            multipartFormData.append(imgDate[i], withName: imageName + "[(i)]", fileName: "photo(i).jpeg" , mimeType: "image/jpeg")
            
        }
        for (key, value) in parameters {
            multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
        }
    },to: url, headers: headers) { (result) in
        //stopAtivityIndicator(sender: sender)
        switch result {
        
        case .success(let upload, _ , _):
            
            upload.uploadProgress(closure: { (progress) in
                
                let total = progress.totalUnitCount
                let obt  = progress.completedUnitCount
                let per = Double(obt) / Double(total) * 100
                let perint = Int(per)
                
                //KRProgressHUD.showMessage("(per)")
                
            })
            
            upload.responseString { response in
                
                //KRProgressHUD.dismiss()
                
                let resp = JSON(response.result.value)
                
                completionHandler(resp, false)
                
                
            }
            
        case .failure(let encodingError):
            
            let a = JSON()
            completionHandler(a as! JSON, true)
            
        }
    }
    
}




func oneStepBackPopUp(msg:String, sender:UIViewController)
{
    let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
    
    let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
        (_)in
        
        sender.navigationController?.popViewController(animated: true)
    })
    myAlert.addAction(OKAction)
    sender.present(myAlert, animated: true, completion: nil)
}

func checkName(name:String) -> Bool
{
    let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
    if name.rangeOfCharacter(from: characterset.inverted) != nil
    {
        return true
    }
    else
    {
        return false
    }
}
func checkNumber(name:String) -> Bool
{
    let characterset = NSCharacterSet(charactersIn: "0123456789")
    if name.rangeOfCharacter(from: characterset.inverted) != nil
    {
        return true
    }
    else
    {
        return false
    }
}
func checkPhone(name:String) -> Bool
{
    let characterset = NSCharacterSet(charactersIn: "+1234567890 ")
    if name.rangeOfCharacter(from: characterset.inverted) != nil
    {
        return true
    }
    else
    {
        return false
    }
}


let headers: HTTPHeaders = [
    "Accept":"application/json",
    "Authorization":"Bearer " + CurrentUser.userData()!.auth_token!
]

let headers2: HTTPHeaders = [
    "Accept":"application/json"
]

func timeInterval(timeAgo:String) -> String
{   
    let df = DateFormatter()
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    df.dateFormat = dateFormat
    let dateWithTime = df.date(from: timeAgo)
    
    let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime!, to: Date())
    
    if let year = interval.year, year > 0 {
        return year == 1 ? "\(year)" + " " + "year ago" : "\(year)" + " " + "years ago"
    } else if let month = interval.month, month > 0 {
        return month == 1 ? "\(month)" + " " + "month ago" : "\(month)" + " " + "months ago"
    } else if let day = interval.day, day > 0 {
        return day == 1 ? "\(day)" + " " + "day ago" : "\(day)" + " " + "days ago"
    }else if let hour = interval.hour, hour > 0 {
        return hour == 1 ? "\(hour)" + " " + "hour ago" : "\(hour)" + " " + "hours ago"
    }else if let minute = interval.minute, minute > 0 {
        return minute == 1 ? "\(minute)" + " " + "minute ago" : "\(minute)" + " " + "minutes ago"
    }else if let second = interval.second, second > 0 {
        return second == 1 ? "\(second)" + " " + "second ago" : "\(second)" + " " + "seconds ago"
    } else {
        return "a moment ago"
        
    }
}
func timeIntervalWithDate(dateWithTime:Date) -> String
{
    //    let df = DateFormatter()
    //    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    //    df.dateFormat = dateFormat
    //    let dateWithTime = df.date(from: timeAgo)
    
    let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime, to: Date())
    
    if let year = interval.year, year > 0 {
        return year == 1 ? "\(year)" + " " + "year ago" : "\(year)" + " " + "years ago"
    } else if let month = interval.month, month > 0 {
        return month == 1 ? "\(month)" + " " + "month ago" : "\(month)" + " " + "months ago"
    } else if let day = interval.day, day > 0 {
        return day == 1 ? "\(day)" + " " + "day ago" : "\(day)" + " " + "days ago"
    }else if let hour = interval.hour, hour > 0 {
        return hour == 1 ? "\(hour)" + " " + "hour ago" : "\(hour)" + " " + "hours ago"
    }else if let minute = interval.minute, minute > 0 {
        return minute == 1 ? "\(minute)" + " " + "minute ago" : "\(minute)" + " " + "minutes ago"
    }else if let second = interval.second, second > 0 {
        return second == 1 ? "\(second)" + " " + "second ago" : "\(second)" + " " + "seconds ago"
    } else {
        return "a moment ago"
        
    }
}

func popView(sender: UIViewController)
{
    sender.navigationController?.interactivePopGestureRecognizer?.delegate = sender as? UIGestureRecognizerDelegate
    sender.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
}
func showProgress(sender: UIViewController)
{
    upperView = UIView(frame: sender.view.frame)
    upperView.backgroundColor = UIColor.black.withAlphaComponent(0.40)
    let loading = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: appColor, padding: 0)
    loading.translatesAutoresizingMaskIntoConstraints = false
    upperView.addSubview(loading)
    NSLayoutConstraint.activate([
        loading.widthAnchor.constraint(equalToConstant: 40),
        loading.heightAnchor.constraint(equalToConstant: 40),
        loading.centerYAnchor.constraint(equalTo: upperView.centerYAnchor),
        loading.centerXAnchor.constraint(equalTo: upperView.centerXAnchor)
    ])
    loading.startAnimating()
    sender.view.addSubview(upperView)
}
func dismisProgress()
{
    upperView.removeFromSuperview()
}









import SystemConfiguration
public class Reach {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}



var upper : UIView?
func startProgress(sender: UIViewController){
    
}


