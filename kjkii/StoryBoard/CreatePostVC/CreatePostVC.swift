//
//  CreatePostVC.swift
//  kjkii
//
//  Created by Shahbaz on 03/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import BSImagePicker
import GrowingTextView
import SwiftyJSON
import Alamofire
class CreatePostVC: UIViewController, UITextViewDelegate{
    @IBOutlet weak var clcView  : UICollectionView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName : APLabel!
    @IBOutlet weak var newPostText: GrowingTextView!
    var imgs = [UIImage]()
    var picArrays      = [UpdatePost]()
    var communityPosts : Posts?
    var idsArray        = [String]()
    var isChanged = false
    var isUpdate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.popView(sender: self)
        UIHelper.shared.setImage(address: CurrentUser.userData()!.profile_pic ?? "", imgView: userImage)
        userName.text = CurrentUser.userData()!.name
        clcView.register(UINib(nibName: "CreatePostImgsCell", bundle: nil), forCellWithReuseIdentifier: "CreatePostImgsCell")
        clcView.delegate = self
        clcView.dataSource = self
        newPostText.delegate = self
        if isUpdate{
            newPostText.text = communityPosts?.body
            for i in 0..<communityPosts!.media!.count{
                let data = UpdatePost(isNew: false, oldImageUrl: communityPosts?.media[i].path , imgId: "\(communityPosts!.media[i].id!)", newImage: UIImage())
                picArrays.append(data)
                clcView.reloadData()
                
            }
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addImageBtn(_ sender: Any) {
        addImages()
    }
    @IBAction func createPostBtn(_ sender: Any) {
        if isChanged{
            if isUpdate{
                updatePost()
            }else{
                createPost()
            }
            
        }
        else{
            showAlert(message: "Empty post is not allowed")
//            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func showAlert(message : String) {
        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        
        let done = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(done)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text!
        if text.count > 0{
            isChanged = true
        }
        else{
            isChanged = false
        }
    }
    
     func API_POST_FORM_DATA(param:[String : String], songData:Data?, fileName:String ,completionHandler: @escaping (_ res:JSON, _ error: Bool)->Void)
    {

        let API_URL = "https://kikii.uk/api/create/post"
        print("API_URL : \(API_URL)")
        let request = NSMutableURLRequest(url: URL(string: API_URL)!)
        request.httpMethod = "POST"
        request.value(forHTTPHeaderField: "Z4IJXMXRYpLxl0ZgttBD810YOdLjL2vy4kEAmcT9wGLc4lRwVIPbS7Plg21c")
        for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)

                }

        let boundary = generateBoundaryString()

        //define the multipart request type

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


        var body = Data()

        let fname = fileName
        let mimetype = "image/png"

        //define the data post parameter

//        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
//
//        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//
//        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        
//        for (key, value) in param
//        {
//            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
//        }

       
        if let songRawData = songData
        {
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"media\"; filename=\"media\"\r\n".data(using: String.Encoding.utf8)!)
//            body.append(songRawData)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(songRawData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
          
           
        }
       

      

//        request.httpBody = body as Data
        let data1 = body as Data
        
        let str = String(decoding: data1, as: UTF8.self)
        // return body as Data
        print("Fire....")
        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest, from: body)
        session.uploadTask(with: request as URLRequest, from: body){
            (
            data, response, error) in
            print("Complete")
            if error != nil
            {
                print("error upload : \(error)")
                let a = JSON()
               completionHandler(a, true)
                return
            }

            do
            {

                if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                {
                    let a = JSON()
                   completionHandler(a, true)
                }else
                {
                    print("Invalid Json")
                }
            }
            catch
            {
                print("Some Error")
                let a = JSON()
               completionHandler(a, true)
            }
        }
        .resume()
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func  MultipleImages(url:String,parameters: Parameters,webCallName:String,imgDate:[Data],imageName: String,comefromEditProfile:Bool,mainProfileImgData:[Data], sender:
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
                multipartFormData.append(imgDate[i], withName: "media[]", fileName: "photo\(i).jpeg" , mimeType: "image/jpeg")

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
   


}

extension CreatePostVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return picArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatePostImgsCell", for: indexPath) as! CreatePostImgsCell
        if picArrays[indexPath.row].isNew{
            cell.attachImage.image = picArrays[indexPath.row].newImage
        }else{
            UIHelper.shared.setImage(address: picArrays[indexPath.row].oldImageUrl ?? "", imgView: cell.attachImage)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let text = newPostText.text!
        //        if text.count > 0 && imgs.count > 0{
        //            isChanged = true
        //        }
        //        else{
        //            isChanged = false
        //        }
        isChanged = true
        if picArrays[indexPath.row].isNew {
            picArrays.remove(at: indexPath.row)
            clcView.reloadData()
        }else{
            self.idsArray.append(self.picArrays[indexPath.row].imgId!)
            picArrays.remove(at: indexPath.row)
            clcView.reloadData()
        }
        //imgs.remove(at: indexPath.row)
        
        
    }
    
    func addImages(){
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max                      = 9
        imagePicker.settings.selection.unselectOnReachingMax    = true
        imagePicker.settings.fetch.assets.supportedMediaTypes   = [.image]
        imagePicker.settings.preview.enabled  = true
        
        presentImagePicker(imagePicker, animated: true,
                           select: { (asset: PHAsset) -> Void in
                           }, deselect: {(asset: PHAsset) -> Void in
                           }, cancel: { (assets: [PHAsset]) -> Void in
                            // User cancelled. And this where the assets currently selected.
                           }, finish: {[unowned self] (assets: [PHAsset]) -> Void in
                            let allImgs = self.getAssetThumbnail(assets: assets)
                            self.imgs.removeAll()
                            for img in allImgs{
                                self.imgs.append(img)
                                let data = UpdatePost(isNew: true, oldImageUrl: "", imgId: "", newImage: img)
                                self.picArrays.append(data)
                            }
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                self.clcView.reloadData()
                                if imgs.count > 0{
                                    isChanged = true
                                }
                                else{
                                    isChanged = false
                                }
                            }
                           }, completion: nil)
        
        
    }
    func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
        var arrayOfImages = [UIImage]()
        for asset in assets {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var image = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                image = result!
                arrayOfImages.append(image)
            })
        }
        return arrayOfImages
    }
    
    func updatePost(){
        showProgress(sender: self)
        var oldimgsAddress = [Data]()
        for i in 0..<picArrays.count{
            if picArrays[i].imgId == ""{
                oldimgsAddress.append(picArrays[i].newImage!.jpegData(compressionQuality: 0.8) ?? Data())
            }
        }
        print(oldimgsAddress)
        let url = EndPoints.BASE_URL + "update/post/" + "\(communityPosts!.id!)"
        let intArray = self.idsArray.map({$0}).joined(separator: ",")
        
        print(intArray)
        let params = ["body":"\(newPostText.text!)","deleted_media_ids":intArray]
        print(params)
        print(url)
        if picArrays.count > 0{
            webCallForMultipleImages(url: url, parameters: params, webCallName: "Updating Posts", imgDate: oldimgsAddress, imageName: "new_media", comefromEditProfile: false, mainProfileImgData: oldimgsAddress, sender: self) { (response, error) in
                print(response)
                if !error{
                    oneStepBackPopUp(msg: "Post Updated", sender: self)
                }
                else{
                    self.alert(message: API_ERROR)
                }
            }
            
            //            createPostWithImages(url: url, parameters: params, webCallName: "", imgData: dataArray) { [weak self] (done) in
            //                guard let self = self else {return}
            //                dismisProgress()
            //                if done
            //                {
            //                    oneStepBackPopUp(msg: "Post Created", sender: self)
            //                }
            //                else{
            //                    self.alert(message: "Could not create post please try later")
            //                }
            //            }
        }
        else{
            postWebCall(url: url, params: params, webCallName: "Posting Text") { (response, error) in
                if !error{
                    oneStepBackPopUp(msg: "Post created", sender: self)
                }
                else{
                    self.alert(message: API_ERROR)
                }
            }
            
        }
        
        
    }
    
    func createPost(){
        if newPostText.text == "" || newPostText.text == nil{
            showAlert(message: "Empty post is not allowed")
        }else{
//        showProgress(sender: self)
        var dataArray = [Data]()
        for img in picArrays
        {
            dataArray.append(img.newImage!.jpegData(compressionQuality: 0.5)!)
        }
        let url = EndPoints.BASE_URL + "create/post"
        let params = ["body":"\(newPostText.text!)"]
//            let params = ["body":"manual way"]
//            API_POST_FORM_DATA(param: params, songData: dataArray[0], fileName: "media") { (JSON, Bool) in
//                print("Json")
//            }
            
//            ManualWay(dataArray: dataArray, param: params)
            let url1 = NSURL(string: url)
            
            // The closure is very convenient
            MultipartUpload.init().postAction(dataArray[0], url: url1!, parameters: params) { (data, response, error) in
                print("-------post")
                let jsonData:NSDictionary = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                print("-------Result: \(jsonData)")
                if !error{
                    DispatchQueue.main.async {
                        oneStepBackPopUp(msg: "Post Created", sender: self)
                    }
//                   
                    print("no error")
                } else{
                   DispatchQueue.main.async {
                    print("some error")
                    self.alert(message: API_ERROR)
                   }
                }
            
//        if picArrays.count > 0{
//            MultipleImages(url: url, parameters: params, webCallName: "Creating Posts", imgDate: dataArray, imageName: "media[]",comefromEditProfile: false,mainProfileImgData: dataArray, sender: self) { (response, error) in
//                if !error{
//                    oneStepBackPopUp(msg: "Post Created", sender: self)
//                }
//                else{
//                    self.alert(message: API_ERROR)
//                }
//            }
//
//            //            createPostWithImages(url: url, parameters: params, webCallName: "", imgData: dataArray) { [weak self] (done) in
//            //                guard let self = self else {return}
//            //                dismisProgress()
//            //                if done
//            //                {
//            //                    oneStepBackPopUp(msg: "Post Created", sender: self)
//            //                }
//            //                else{
//            //                    self.alert(message: "Could not create post please try later")
//            //                }
//            //            }
//        }
//        else{
//            postWebCall(url: url, params: params, webCallName: "Posting Text") { (response, error) in
//                if !error{
//                    oneStepBackPopUp(msg: "Post created", sender: self)
//                }
//                else{
//                    self.alert(message: API_ERROR)
//                }
//            }
//
//        }


    }
        

        
        
    }
   
}
struct UpdatePost {
    var isNew           = Bool()
    var oldImageUrl     : String?
    var imgId           : String?
    var newImage        : UIImage?
}
//extension Data {
//
//    /// Append string to Data
//    ///
//    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
//    ///
//    /// - parameter string:       The string to be added to the `Data`.
//
//    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
//        if let data = string.data(using: encoding) {
//            append(data)
//        }
//    }
//}




// Declare a closure, then use the callback when you use it
}

typealias postActionClosure = (_ data: Data, _ response: URLResponse, _ error: Bool) -> Void

class MultipartUpload {
    var myClosure: postActionClosure?
    func postAction(_ imageData: Data, url: NSURL, parameters: [String : Any], closure: @escaping postActionClosure) {
        // Function pointer assigned to myClosure closure
        self.myClosure = closure
        // Create a boundary that acts as a split
        let boundary = getRandomBoundary()
        // Create a network request object
        let request = NSMutableURLRequest(url: url as URL)

        // Construct the request body from here
        // Store the array of parameters, and then turn into a string, which is the request body
        let body  = NSMutableArray()
        // splicing parameters and boundary temporary variables
        var fileTmpStr = ""
        if parameters.count > 0 {
            // Set to POST request
            request.httpMethod = "POST"
            for (key, value) in headers {
                        request.setValue(value, forHTTPHeaderField: key)

                    }
            request.setValue("multipart/form-data; boundary=----\(boundary)", forHTTPHeaderField: "Content-Type")
            // Split the dictionary, parameter is one of them, the key and value into a string
            for parameter in parameters {
                // assemble boundary and parameter together
                fileTmpStr = "------\(boundary)\r\nContent-Disposition: form-data; name=\"\(parameter.0)\"\r\n\r\n\(parameter.1)\r\n"
                body.add(fileTmpStr)
            }
            // Upload the file name of the file, just name it as required.
            let filename = "media[]"
            // assemble the file name and boundary together
            fileTmpStr = "------\(boundary)\r\nContent-Disposition: form-data; name=\"media[]\"; filename=\"\(filename)\"\r\n"
            body.add(fileTmpStr)
            // The file type is image, png, jpeg free
            fileTmpStr = "Content-Type: image/png\r\n\r\n"
            body.add(fileTmpStr)
            // Turn the contents of the body into a string
            let parameterStr = body.componentsJoined(by: "")
            // UTF8 transcodes to prevent illegal URLs caused by Chinese characters
            var parameterData = parameterStr.data(using: String.Encoding.utf8)!
            // Append the image to the parameterData
            parameterData.append(imageData)
            // Add the end of the boundary to the parameterData
            parameterData.append("\r\n------\(boundary)--".data(using: String.Encoding.utf8)!)
            // Set the request body
            request.httpBody = parameterData
            // Default session configuration
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            //Initiate a request
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if data != nil {
//                    if let closure = self.ocrClosure
                    if error == nil{
                        closure(data!, response!, false)
                    }else{
                        closure(data!, response!, true)
                    }
                    
                }
            }
            //Request to start
            dataTask.resume()
        }
    }
    // MARK: - get boundary
        func getRandomBoundary() -> String {
            // This Boundary is a random number
            return String(format: "WebKitFormBoundary%08x%08x", arc4random(), arc4random())
        }

}


