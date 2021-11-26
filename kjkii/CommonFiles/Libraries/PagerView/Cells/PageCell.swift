//
//  PageCell.swift
//  QaisApp
//
//  Created by Zuhair Hussain on 14/05/2019.
//  Copyright © 2019 Target. All rights reserved.
//

import UIKit
import Kingfisher
//import KRProgressHUD

//import SDWebImage   // or Kingfisher
@objc protocol PageCellDelegate {
    @objc func pageCell(didStartedDownoladingImage:Bool)
    @objc func pageCell(error:NSError?, didFinishDownloading:Bool)
}

class PageCell: UICollectionViewCell {
    
    var delegate:PageCellDelegate?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ data: PagerView.PageModel, kfOptions:KingfisherOptionsInfo?) {
        //print ("\nActivity: \(self.activityIndicator.isAnimating) \n")
        if data.image != nil {
            imageView.image = data.image
        } else {
            imageView.setImage(url: data.url, placeholder: data.placeholder,kfOptions:kfOptions, completion: { [weak self] (error, isDownloading, isCompleted) in
                if let self = self, (isDownloading && isCompleted==false && !self.activityIndicator.isAnimating) {
                    self.errorLabel.isHidden = true
                    self.activityIndicator.startAnimating()
                    self.delegate?.pageCell(didStartedDownoladingImage: isDownloading)
                }
                if (isDownloading==false  && isCompleted) {
                    self?.delegate?.pageCell(error:nil, didFinishDownloading: isCompleted)
                    self?.activityIndicator.stopAnimating()
                }
                if (error != nil) {
                    self?.delegate?.pageCell(error:error, didFinishDownloading: false)
                    self?.activityIndicator.stopAnimating()
                    self?.errorLabel.text = "" //error?.localizedDescription
                    self?.errorLabel.isHidden = false
                    let code = error?.userInfo["statusCode"]
                    print("\nDownloading Failed Error: \(error!), Code: \(code ?? "None")\n")
                }
            })
        }
    }
}

extension UIImageView {
    func setImage(url: URL?, placeholder: UIImage? = nil, kfOptions:KingfisherOptionsInfo?, completion:@escaping (_ error:NSError?, _ isDownloading:Bool, _ isCompleted:Bool)->Void) {
        //showActivityIndicatory(uiView: self)
        //if let u = url {
            //completion(nil, true, false)
            /*
            //self.kf.setImage(with: u)
            self.kf.setImage(with: u, placeholder: placeholder, options: kfOptions, progressBlock: { (it1, it2) in
//                completion(true, false)
                completion(nil, true, false)
            }) { (image, error, cacheType, url) in
                if let error = error {
                    completion(error, false,false)
                    //print("Error: \(error.localizedDescription)\n")
                }
                else {
                    completion(nil, false, true)
                }
                print("Cache Type: \(cacheType)\n")
            }
             */
            
        //} else {
        //    self.image = placeholder
        //}
    }
}

/*
            self.kf.setImage(with: u , placeholder: placeholder, options: nil, progressBlock: { (it1, it2) in
               //if KRProgressHUD.isVisible == false {
                    //completion(true, false)
                    /* DispatchQueue.main.asyncAfter(deadline: .now()) {
                        let height = (self.window?.frame.height ?? 667)
                        let offset = height/2 - (28 + (209.5)*(height/667))
                        KRProgressHUD.set(viewOffset: -offset).set(style: KRProgressHUDStyle.custom(background: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0), text: .white, icon: .red)).set(activityIndicatorViewColors: [.black, .clear]).show()
                        print("hight: \(height)")
                    } */
                    /*SVProgressHUD.setOffsetFromCenter(UIOffset.init(horizontal: 0, vertical: -1*(self.window?.frame.height ?? 667)/4.76))
                     SVProgressHUD.setBackgroundColor(.clear)
                     SVProgressHUD.show()
                     */
                //}
                if it1 == it2 {
                    /*SVProgressHUD.dismiss()
                     DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                     SVProgressHUD.resetOffsetFromCenter()
                     SVProgressHUD.setBackgroundColor(.white)
                     })
                     */
//                    KRProgressHUD.dismiss()
                    
                }
            }, completionHandler: nil)
*/
