//
//  pagerControllerSetup.swift
//  Dryclean
//
//  Created by abbas on 31/05/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

@objc class PageSetup:NSObject {
    
    //@objc func setupSliderImageDownloadOptions(_ pagerViewController: PagerView, kfOptions:Int) {
    //}
    @objc func setupSlider(pagerViewController: PagerView, urlStrings:[String], kfOptions:Int = 1){
        
       // let url1 = "http://cdn.ssasoft.com/DryClean/Promotion_Mobile_URL.jpg"
       // let url2 = "http://cdn.ssasoft.com/DryClean/Promotion_Web_URL.jpg"
       // let urlStrings = [url1, url2];
        pagerViewController.kfOptions = (kfOptions == 1) ? [.fromMemoryCacheOrRefresh] : [.forceRefresh]
        pagerViewController.set(urlStrings: urlStrings)
        pagerViewController.startPaging()
        
        //        let imagesTitle = ["Slide1","Slide2","Slide3","Slide4"]
        //        for imageTitle in imagesTitle {
        //            pagerViewController.add(image: UIImage.init(named: imageTitle)!)
        //         }
    }
    @objc func stopPaging(pagerViewController: PagerView){
        pagerViewController.stopPaging()
    }
}
