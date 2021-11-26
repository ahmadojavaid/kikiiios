//
//  Banners.swift
//  kjkii
//
//  Created by Saeed Rehman on 01/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit

class Banners: UIViewController {
    
    @IBOutlet weak var collection_view: UICollectionView!
    var  current_row_index = 0
    var timer = Timer()
    var bannerList = [BannerImages]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collection_view.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
        collection_view.delegate = self
        collection_view.dataSource = self
        getbannersImages()
        runTimer()
        // Do any additional setup after loading the view.
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
                        self.collection_view.reloadData()
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
extension Banners:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        UIHelper.shared.setImage(address: bannerList[indexPath.row].path ?? "", imgView: cell.bannerImage)
        cell.cellHeight.constant = self.collection_view.frame.size.height
        cell.cellWidth.constant =  self.collection_view.frame.size.width
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let url = URL(string: bannerList[indexPath.row].link!) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @objc func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: Double(3), target: self, selector: #selector(runTimer), userInfo: nil, repeats: false)
        if bannerList.count > 0
        {
            current_row_index = current_row_index + 1
            collection_view.scrollToItem(at: IndexPath(row: current_row_index, section: 0), at: .right, animated: true)
            if current_row_index == 9
            {
                current_row_index = 0
            }
            //pageControl.currentPage = current_row_index
        }
        
    }
}
