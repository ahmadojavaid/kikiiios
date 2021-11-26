//  EditProfileVC.swift
//  kjkii
//  Created by Shahbaz on 05/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import ProgressHUD

class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    @IBOutlet weak var instaImgVu: UIImageView!
    
    @IBOutlet weak var tiktokImgVu: UIImageView!
    @IBOutlet weak var fbImgVu: UIImageView!
    @IBOutlet weak var mainProfileImgBtn: UIButton!
    @IBOutlet weak var profileImgVu: UIImageView!
    @IBOutlet weak var locationSwitch   : UISwitch!
    @IBOutlet weak var incognitoSwitch  : UISwitch!
//    @IBOutlet var profileImages         : [UIImageView]!
    
    @IBOutlet var profileImages: [UIImageView]!
    
    @IBOutlet weak var clcView          : UICollectionView!
    @IBOutlet weak var genderIdentity   : APLabel!
    @IBOutlet weak var sexualIdentity   : APLabel!
    @IBOutlet weak var pronouns         : APLabel!
    @IBOutlet weak var bioLabel         : APLabel!
    var user                            : MeetUsers?
    var selectedValue                   = String()
    var selectedOption                  : EditProfileType = .gender
    var selectedIndex                   = Int()
    var isPaid                          = false
    var HeightChanges                   = ""
    var instaURL                        = ""
    var fbURL                           = ""
    var tiktokURL                       = ""
    var imagePicker = UIImagePickerController()
    var btnTag = 0
    var imagesDataArray = [UIImage]()
    var mainProfileImage : UIImage?
    
    @IBOutlet weak var delBtn1: UIButton!
    
    @IBOutlet weak var delBtn2: UIButton!
    
    @IBOutlet weak var delBtn3: UIButton!
    
    @IBOutlet weak var delBtn4: UIButton!
    @IBOutlet weak var delBtn5: UIButton!
    @IBOutlet weak var delBtn6: UIButton!
    
    @IBOutlet weak var delBtn8: UIButton!
    @IBOutlet weak var delBtn7: UIButton!
    
    var userUploaded = [false,false,false,false,false,false,false,false]
    var imagesIDArray = [String]()
    var deletedImagesIDArray = [String]()
    var comeFromMainPic = false
    
    struct userUploadedImages {
        var btnTag = 0
        var image : UIImage?
    }
    var userUploadImageObj = [userUploadedImages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideDelBtns()
        UIHelper.shared.popView(sender: self)
        clcView.register(UINib(nibName: "CurCell", bundle: nil), forCellWithReuseIdentifier: "CurCell")
        clcView.delegate    = self
        clcView.dataSource  = self
        incognitoSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        locationSwitch.addTarget(self, action: #selector(locationSwitchPressed), for: UIControl.Event.valueChanged)
        setValues()
        

    }
    @IBAction func btntikTokPressed(_ sender: Any) {
        let vc = SocialVc(nibName: "SocialVc", bundle: .main)
        vc.title_string = ""
        vc.oldText = tiktokURL
        vc.configure { (text) in
            print("tiktok")
            print(text)
            self.tiktokURL = text
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btninstaPressed(_ sender: Any) {
        
        let vc = SocialVc(nibName: "SocialVc", bundle: .main)
        vc.title_string = "insta"
        vc.oldText = instaURL
        vc.configure { (text) in
            print(text)
            self.instaURL = text
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func btnFacebookPressed(_ sender: Any) {
        let vc = SocialVc(nibName: "SocialVc", bundle: .main)
        vc.title_string = "fb"
        vc.oldText = fbURL
        vc.configure { (text) in
            print(text)
            self.fbURL = text
        }
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    @objc func locationSwitchPressed(mySwitch: UISwitch) {
        if mySwitch.isOn{
            appDelegate.manager.startUpdatingLocation()
        }else{
            appDelegate.manager.stopUpdatingLocation()
        }
    }
    @objc func switchChanged(mySwitch: UISwitch) {
        if mySwitch.isOn{
            print("**********")
            print(DEFAULTS.string(forKey: "isPaid"))
            if DEFAULTS.string(forKey: "isPaid") == "0"{
                let stb = UIStoryboard(name: "Main", bundle: nil)
                let vc = stb.instantiateViewController(withIdentifier: "SubscriptioVC") as! SubscriptioVC
                vc.hidesBottomBarWhenPushed     = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if DEFAULTS.string(forKey: "isPaid") == "0"{
            isPaid = false
        }else{
            isPaid = true
        }
        if !isPaid{
            self.incognitoSwitch.setOn(false, animated: true)
        }else{
            self.incognitoSwitch.setOn(true, animated: true)
        }
    }
    @IBAction func backBtnPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func setValues(){
        if let user = user{
            setImages(user: user)
            genderIdentity.text     = user.gender_identity
            sexualIdentity.text     = user.sexual_identity
            pronouns.text           = user.pronouns
            bioLabel.text           = user.bio
            if user.relationship_status ?? "" != ""{
                AppData.curOptions[0]   = user.relationship_status    ?? ""
                AppData.curOptions[1]   = user.height                 ?? ""
                AppData.curOptions[2]   = user.looking_for            ?? ""
                AppData.curOptions[3]   = user.drink                  ?? ""
                AppData.curOptions[4]   = user.smoke                  ?? ""
                AppData.curOptions[5]   = user.cannabis               ?? ""
                AppData.curOptions[6]   = user.political_views        ?? ""
                AppData.curOptions[7]   = user.religion               ?? ""
                AppData.curOptions[8]   = user.diet_like              ?? ""
                AppData.curOptions[9]   = user.sign                   ?? ""
                AppData.curOptions[10]  = user.pets                   ?? ""
                AppData.curOptions[11]  = user.kids                   ?? ""
            }
            if user.facebook != nil && user.facebook != ""{
                fbURL = user.facebook!
                fbImgVu.image = UIImage(named: "fbfilled")
            }
            if user.instagram != nil && user.instagram != ""{
                instaURL = user.instagram!
                instaImgVu.image = UIImage(named: "insta")
            }
            if user.tiktok != nil && user.tiktok != ""{
                tiktokURL = user.tiktok!
                tiktokImgVu.image = UIImage(named: "tiktokfilled")
            }
        }
        
    }
    func setImages(user: MeetUsers){
        profileImgVu.sd_setImage(with: URL(string: user.profile_pic!))
//        imagesDataArray.append((profileImages[0].image ?? UIImage(named: "btn_plus"))!)
        if let pics = user.profile_pics{
            if pics.count > 9{
                for i in 0...6{
//                    UIHelper.shared.setImage(address: pics[i].path ?? "", imgView: profileImages[i])
                    profileImages[i].sd_setImage(with: URL(string: pics[i].path!))
                    profileImages[i].sd_setImage(with: URL(string: pics[i].path!)) { [self] (_: UIImage?, _: Error?, SDImageCacheType, _: URL?) in
                        let newImage = profileImages[i].image
                        imagesIDArray.append(String(pics[i].id!))
                       
                        imagesDataArray.append(newImage!)
                        UnhideSpecificDelBtn(index: i)
                    }
                    
                }
            }
            else{
                for i in 0 ..< pics.count{
//                    UIHelper.shared.setImage(address: pics[i].path ?? "", imgView: profileImages[i])
                   
                      
                   
                   
//                    profileImages[i].sd_setImage(with: URL(string: pics[i].path!)) { [self] (_: UIImage?, _: Error?, SDImageCacheType, _: URL?) in
//                        let newImage = profileImages[i].image
//
//                        imagesDataArray.append(newImage!)
//                        imagesIDArray.append(String(pics[i].id!))
//                        UnhideSpecificDelBtn(index: i)
//                    }
//                    starting new method
                    let url = URL(string: pics[i].path!)
//
                    print("this is messing \(url)")
                    UIHelper.shared.setImage(address: pics[i].path ?? "", imgView: profileImages[i])
                    self.imagesIDArray.append(String(pics[i].id!))
                    self.UnhideSpecificDelBtn(index: i)
                   
                   
                   
                    
                
                }
            }
            
        }
 
    }
    
    @IBAction func genderBtnPressed(_ sender: Any) {
        selectedOption = .gender
        selectedValue = EditProfileCategories.GENDER_IDENTITY
        getValues()
    }
    
    @IBAction func sexualIdentityBtnPressed(_ sender: Any) {
        selectedOption = .sex
        selectedValue = EditProfileCategories.SEXUAL_IDENTITY
        getValues()
    }
    @IBAction func pronounsBtnPressed(_ sender: Any) {
        selectedOption = .pro
        selectedValue = EditProfileCategories.PRONOUNS
        getValues()
    }
    
    func getValues(){
        let vc = EditProfileDataVC(nibName: "EditProfileDataVC", bundle: nil)
        vc.optionsToGet = selectedValue
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bioEditBtnPressed(_ sender: Any) {
        let vc = EditBioVC(nibName: "EditBioVC", bundle: nil)
        vc.myBio = user!.bio ?? ""
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updateProfilePressed(_ sender: Any) {
        var dataArray = [Data]()
        var mainProfiledata = [Data]()
        dataArray.removeAll()
        var deletedIDString = ""
        if deletedImagesIDArray.isEmpty == false{
            deletedIDString = deletedImagesIDArray[0]
        }

        if userUploadImageObj.count != 0{
            for obj in userUploadImageObj{
                let newImage = obj.image
                dataArray.append(newImage!.jpegData(compressionQuality: 0.5)!)
            }
        }
        if mainProfileImage != nil{
            mainProfiledata.append(mainProfileImage!.jpegData(compressionQuality: 0.5)!)
        }
        
        if deletedImagesIDArray.count != 0{
        for i in 1..<deletedImagesIDArray.count{
            let idString = deletedImagesIDArray[i]
            
            deletedIDString = deletedIDString + "," + idString
            
        }
        }
        
        
        let url = BASE_URL + "update/profile"
//        let url = "https://kikii.uk/api/update/profile"
        let params =
            [        "gender_identity":genderIdentity.text ?? "",
                      "sexual_identity":sexualIdentity.text ?? "",
                      "pronouns":pronouns.text ?? "",
                      "bio":bioLabel.text ?? "",
                      "relationship_status":"\(AppData.curOptions[0])",
                      "height":"\(AppData.curOptions[1])",
                      "looking_for":"\(AppData.curOptions[2])",
                      "drink":"\(AppData.curOptions[3])",
                      "smoke":"\(AppData.curOptions[4])",
                      "cannabis":"\(AppData.curOptions[5])",
                      "political_views":"\(AppData.curOptions[6])",
                      "religion":"\(AppData.curOptions[7])",
                      "diet_like":"\(AppData.curOptions[8])",
                      "sign":"\(AppData.curOptions[9])",
                      "pets":"\(AppData.curOptions[10])",
                      "kids":"\(AppData.curOptions[11])",
                      "latitude":"\(appDelegate.lat)",
                      "longitude":"\(appDelegate.lng)",
                      "facebook":self.fbURL,
                      "instagram":self.instaURL,
                      "tiktok":self.tiktokURL,
                      "deleted_pics": deletedIDString
            ]
        
        print(params)
        postWebCall(url: url, params: params, webCallName: "Updating Profile", sender: self) { [unowned self](response, error) in
                print("***********************")
                print(response)
                if !error{
                    DispatchQueue.main.async {
                        ProgressHUD.show()
                    }
                   
                    webCallForMultipleImages(url: url, parameters: params, webCallName: "Creating Posts", imgDate: dataArray, imageName: "new_pics",comefromEditProfile: true,mainProfileImgData: mainProfiledata,sender: self) { (response, error) in
                        print("***********************")
                        print(response)
                        if !error{
                        
                            ProgressHUD.dismiss()
                            oneStepBackPopUp(msg: "\(response["message"])", sender: self)
                           
                           
                        }
                        else{
                            ProgressHUD.dismiss()
                            self.alert(message: API_ERROR)
                        }
                    }
                   
                   
                }
                else{
                    self.alert(message: API_ERROR)
                }
            }
        
        
//        webCallForMultipleImages(url: url, parameters: params, webCallName: "Creating Posts", imgDate: dataArray, imageName: "new_pics", sender: self) { (response, error) in
//            print("***********************")
//            print(response)
//            if !error{
//                oneStepBackPopUp(msg: "\(response["message"])", sender: self)
//               
//               
//            }
//            else{
//                self.alert(message: API_ERROR)
//            }
//        }
    }
    @IBAction func addImageBtnTpd(_ sender: UIButton) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { [self] action -> Void in
            btnTag = sender.tag
            print("First Action pressed")
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }

        let secondAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { [self] action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                      print("Button capture")
                btnTag = sender.tag
              imagePicker.delegate = self
                      imagePicker.sourceType = .savedPhotosAlbum
                      imagePicker.allowsEditing = false
                      
                      present(imagePicker, animated: true, completion: nil)
                  }

            print("Second Action pressed")
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)

        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if comeFromMainPic{
                comeFromMainPic = false
                profileImgVu.image = image
                mainProfileImage = image
            }else{
             imagesDataArray.append(image)
            profileImages[btnTag].image = image
            UnhideSpecificDelBtn(index: btnTag)
            userUploaded[btnTag] = true
            let newImageObj = userUploadedImages(btnTag: btnTag, image: image)
            userUploadImageObj.append(newImageObj)
        }
          
          self.dismiss(animated: true, completion: nil)
        }
        
    }
    func hideDelBtns(){
        delBtn1.isHidden = true
        delBtn2.isHidden = true
        delBtn3.isHidden = true
        delBtn4.isHidden = true
        delBtn5.isHidden = true
        delBtn6.isHidden = true
        delBtn7.isHidden = true
        delBtn8.isHidden = true
    }
    func UnhideSpecificDelBtn(index: Int){
        switch index{
        case 0:
            delBtn1.isHidden = false
        case 1:
            delBtn2.isHidden = false
        case 2:
            delBtn3.isHidden = false
        case 3:
            delBtn4.isHidden = false
        case 4:
            delBtn5.isHidden = false
        case 5:
            delBtn6.isHidden = false
        case 6:
            delBtn7.isHidden = false
        case 7:
            delBtn8.isHidden = false
        
        default:
            print("nothing")
        }
    }
    func hideSpecificDelBtn(index: Int){
        switch index{
        case 0:
            delBtn1.isHidden = true
        case 1:
            delBtn2.isHidden = true
        case 2:
            delBtn3.isHidden = true
        case 3:
            delBtn4.isHidden = true
        case 4:
            delBtn5.isHidden = true
        case 5:
            delBtn6.isHidden = true
        case 6:
            delBtn7.isHidden = true
        case 7:
            delBtn8.isHidden = true
        
        default:
            print("nothing")
        }
    }
    func UnhideDelBtns(){
        delBtn1.isHidden = false
        delBtn2.isHidden = false
        delBtn3.isHidden = false
        delBtn4.isHidden = false
        delBtn5.isHidden = false
        delBtn6.isHidden = false
        delBtn7.isHidden = false
        delBtn8.isHidden = false
    }
    
    
    @IBAction func deleteBtnTpd(_ sender: UIButton) {
        let tag = sender.tag + 1
        var Arrayindex = 50
        profileImages[sender.tag].image = UIImage(named: "btn_plus")
        
        hideSpecificDelBtn(index: sender.tag)
        profileImages[sender.tag].image = nil
        if userUploaded[sender.tag] == false{
            deletedImagesIDArray.append(imagesIDArray[sender.tag])
        }else{
            if userUploadImageObj.count != 0{
                for i in 0..<userUploadImageObj.count{
                    if userUploadImageObj[i].btnTag == sender.tag{
                        Arrayindex = i
                    }
            }
        }
            if Arrayindex != 50{
                userUploadImageObj.remove(at: Arrayindex)
            }
        }
//        imagesDataArray.remove(at: tag)
    }
    
    
    @IBAction func mainProfileBtnTpd(_ sender: Any) {
      
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { [self] action -> Void in
           
            print("First Action pressed")
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            comeFromMainPic = true
            self.present(imagePicker, animated: true, completion: nil)
        }

        let secondAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { [self] action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                      print("Button capture")
               
              imagePicker.delegate = self
                      imagePicker.sourceType = .savedPhotosAlbum
                      imagePicker.allowsEditing = false
                comeFromMainPic = true
                      present(imagePicker, animated: true, completion: nil)
                  }

            print("Second Action pressed")
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            self.comeFromMainPic = false
        }

        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)

        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    
    
    
}

extension EditProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return AppData.curOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurCell", for: indexPath) as! CurCell
        cell.configCell(item: AppData.curOptions[indexPath.row])
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = AppData.curOptions[indexPath.row] + "   "
        label.sizeToFit()
        return CGSize(width: label.frame.width + 58, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex       = indexPath.row
        selectedOption      = .menu
        switch indexPath.row {
        case 0:
            selectedValue   = EditProfileCategories.RELATIONSHIP_STATUS
        case 1:
            selectedValue   = EditProfileCategories.HEIGHT
        case 2:
            selectedValue   = EditProfileCategories.LOOKING_FOR
        case 3:
            selectedValue   = EditProfileCategories.DRINK
        case 4:
            selectedValue   = EditProfileCategories.SMOKE
        case 5:
            selectedValue   = EditProfileCategories.CANNABIS
        case 6:
            selectedValue   = EditProfileCategories.POLITICAL_VIEWS
        case 7:
            selectedValue   = EditProfileCategories.RELIGION
        case 8:
            selectedValue   = EditProfileCategories.DIET_LIKE
        case 9:
            selectedValue   = EditProfileCategories.SIGN
        case 10:
            selectedValue   = EditProfileCategories.PETS
        case 11:
            selectedValue   = EditProfileCategories.KIDS
        default:
            print("Nooo. noo...")
        }
        getValues()
    }
}

extension EditProfileVC: EditValue, EditBio{
    func bioChanged(text: String) {
        bioLabel.text = text
    }
    func selectedValue(selectedValue: String) {
        if selectedOption == .gender{
            genderIdentity.text = selectedValue
        } else if selectedOption == .sex{
            sexualIdentity.text = selectedValue
        } else if selectedOption == .pro{
            pronouns.text = selectedValue
        } else if selectedOption == .menu{
            AppData.curOptions[selectedIndex] = selectedValue
        }
        clcView.reloadData()
    }
}
