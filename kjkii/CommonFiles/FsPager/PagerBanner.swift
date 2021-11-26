//
//  PagerBanner.swift
//  kjkii
//
//  Created by Saeed Rehman on 04/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit
import FSPagerView
class PagerBanner: UIViewController {
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var containerView: UIView!
    var  current_row_index = 0
    var timer = Timer()
    var bannerList = [BannerImages]()
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.dataSource = self
        pagerView.delegate   = self
        pagerView.register(UINib(nibName: "PagerBannerCellCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "PagerBannerCellCollectionViewCell")
        getbannersImages()
        //         Do any additional setup after loading the view.
    }
    
    
    func getbannersImages(){
        let url = EndPoints.BASE_URL + "ad-images"
        let param = ["":""]
        getWebCallWithTokenWithCodeAble(url: url, params: param, webCallName: "", sender: self) { (response, error) in
            if !error{
                
                let data = response.data(using: .utf8)!
                do
                {
                    self.bannerList.removeAll()
                    let response = try JSONDecoder().decode(BannerStruct.self, from: data)
                    if let  imagess = response.images {
                        self.bannerList = imagess
                        self.pagerView.reloadData()
                    }
                    
                    else{
                        self.alert(message: "Banners is not excist")
                    }
                    
                    
                }
                catch (let error){
                    print(error.localizedDescription)
                }
                
                
                
            }else{
                self.alert(message: API_ERROR)
            }
        }
    }
    
    
}
extension PagerBanner:FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "PagerBannerCellCollectionViewCell", at: index)
//        UIHelper.shared.setImage(address: bannerList[index].path ?? "", imgView: cell.bannerImage)
        return cell
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
        
        
        guard let url = URL(string: bannerList[index].link!) else {
             return
        }

        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView){
        print("WillBeginDrag") }
    
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        print("WillEndDrag")
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        
    }
    
    @objc func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: Double(3), target: self, selector: #selector(runTimer), userInfo: nil, repeats: false)
        if bannerList.count > 0
        {
            current_row_index = current_row_index + 1
            pagerView.scrollToItem(at: current_row_index, animated: true)
            //        pagerView.scrollToItem(at: IndexPath(row: current_row_index, section: 0), at: .right, animated: true)
            if current_row_index == 9
            {
                current_row_index = 0
            }
            //pageControl.currentPage = current_row_index
        }
        
    }
    
}

