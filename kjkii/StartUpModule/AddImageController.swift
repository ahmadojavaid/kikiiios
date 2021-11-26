//
//  AddImageController.swift
//  kjkii
//
//  Created by abbas on 7/27/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import KRProgressHUD

class AddImageController: UIViewController, ImagePickerDelegate
{
    func video(url: URL?) {
        
    }
    
    @IBOutlet weak var detectingView: UIView!
    @IBOutlet weak var faceLbl: APLabel!
    @IBOutlet weak var addImgBnt    : APButton!
    @IBOutlet weak var imageView    : UIView!
    @IBOutlet weak var user_image   : UIImageView!
    var imagePicker                 : ImagePicker!
    var imageUploaded               = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView.addShadow()
        //user_image.addShadow()
        detectingView.isHidden = true
        faceLbl.isHidden = true
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func addImageBtn(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    func didSelect(image: UIImage?) {
        detectingView.isHidden = false
        if image != nil{
        if let img = image
        {
            DispatchQueue.global(qos: .background).async {
                if let inputImage = image {
                    let ciImage = CIImage(cgImage: inputImage.cgImage!)
                    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
                    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
                    let faces = faceDetector.features(in: ciImage)
                    DispatchQueue.main.async {
                        
                        if let _ = faces.first as? CIFaceFeature {
                            self.detectingView.isHidden = true
                            self.imageUploaded       = true
                            self.user_image.image    = img
                            self.addImgBnt.isHidden  = true
                        }
                        else{
                            self.detectingView.isHidden = true
                            self.faceLbl.isHidden = true
                            self.alert(message: "No face detected in the picture, please another one")
                        }
                    }
                    
                }
            }
        }
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: Any)
    {
        
        if imageUploaded
        {
            showProgress(sender: self)
            let url = EndPoints.BASE_URL + "update/profile"
            let data = user_image.image?.pngData()
            webCallWithImageWithName(url: url, parameters: ["":""], webCallName: "Adding Image", imgData: data!, imageName: "profile_pic") { [unowned self] (done) in
                dismisProgress()
                if done{
                    gotoNextScreen()
                }
                else{
                    self.alert(message: API_ERROR)
                }
            }
        }
        else{
            self.alert(message: "Please Add your image")
        }
        
    }
    
    
    func gotoNextScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePicController") as! ProfilePicController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
