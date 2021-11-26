//
//  ProfilePicController.swift
//  kjkii
//
//  Created by abbas on 7/27/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import BSImagePicker

class ProfilePicController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var imgs = [ProfileImages]()
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var collectionView   : UICollectionView!
    var itemNo = 0
    var imagesCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate         = self
        collectionView.dataSource       = self
        collectionView.register(UINib(nibName: "ProfilePicsCell", bundle: .main), forCellWithReuseIdentifier: "ProfilePicsCell")
        for _ in 0..<9{
            imgs.append(ProfileImages(attached: false, img: UIImage(named: "btn_plus")!))
        }
        
        collectionView.reloadData()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //layoutCollectionView()
    }
    
    @IBAction func btnNext(_ sender: Any) {
        var dataArray = [Data]()
//        if imgs.count > 0 {
        if imagesCount >= 3{
            showProgress(sender: self)
            for img in imgs
            {
                if img.attached{
//                    dataArray.append(img.img.pngData()!)
                    dataArray.append(img.img.jpegData(compressionQuality: 0.5)!)
                }
            }
            
            let url = EndPoints.BASE_URL + "update/profile"
            let params = ["":""]
            
            webCallForMultipleImages(url: url, parameters: params, webCallName: "Creating Posts", imgDate: dataArray, imageName: "new_pics",comefromEditProfile: false,mainProfileImgData: dataArray,sender: self) { (response, error) in
                dismisProgress()
                if !error{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! MainTabBarController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else
                {
                    self.alert(message: API_ERROR.description)
                    
                }
            }
            
            //            webCallWithImageArray(url: url, parameters: params, webCallName: "", imgData: dataArray) { (done) in
            //                dismisProgress()
            //                if done
            //                {
            //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! MainTabBarController
            //                    self.navigationController?.pushViewController(vc, animated: true)
            //                }
            //            }
        }
        else{
            self.alert(message: "Please Attach minimum three images")
        }
        
        
        
    }
}

extension ProfilePicController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePicsCell", for: indexPath) as! ProfilePicsCell
        cell.imgView.image = imgs[indexPath.row].img
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemNo = indexPath.item
        addImages1()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: collectionView.bounds.width / 3)
    }
    func addImages1(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                  print("Button capture")
           imagePicker.delegate = self
                  imagePicker.sourceType = .savedPhotosAlbum
                  imagePicker.allowsEditing = false
                  
                  present(imagePicker, animated: true, completion: nil)
              }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let newImage : ProfileImages = ProfileImages(attached: true, img: image)
            imgs[itemNo] = newImage
            imagesCount = imagesCount + 1
           
            collectionView.reloadData()
               
          self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func addImages(){
        let imagePicker                                         = ImagePickerController()
        imagePicker.settings.selection.max                      = 9
        //        imagePicker.settings.selection.unselectOnReachingMax    = true
        imagePicker.settings.fetch.assets.supportedMediaTypes   = [.image, .video]
        imagePicker.settings.preview.enabled  = true
        
        presentImagePicker(imagePicker, animated: true,
                           select: { (asset: PHAsset) -> Void in
                            // User selected an asset.
                            // Do something with it, start upload perhaps?
                           }, deselect: {(asset: PHAsset) -> Void in
                            // User deselected an assets.
                            // Do something, cancel upload?
                           }, cancel: { (assets: [PHAsset]) -> Void in
                            // User cancelled. And this where the assets currently selected.
                           }, finish: {[unowned self] (assets: [PHAsset]) -> Void in
                            let allImgs = self.getAssetThumbnail(assets: assets)
                            for i in 0..<allImgs.count{
                                imgs[i].img         = allImgs[i]
                                imgs[i].attached    = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                self.collectionView.reloadData()
                            }
                            
                           }, completion: nil)
    }
    
    
    
}

extension ProfilePicController {
    func layoutCollectionView() {
        //let widthRation = CGFloat(375.0/415.0)
        let edgeInset:CGFloat =  0 //* widthRation
        //let viewWidth:CGFloat = 400.0 //(.bounds.size.width - (40.0 * widthRation))/3.0
        let width = collectionView.frame.size.width/3 - 1
        let height = width
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 0.0 //* widthRation // Veritical Space
        layout.minimumLineSpacing = 0.0 //* widthRation      // HorizSpace
        //layout.headerReferenceSize = CGSize(width: 0, height: 35)
        layout.sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
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
}



struct ProfileImages {
    var attached    = Bool()
    var img         = UIImage()
}
