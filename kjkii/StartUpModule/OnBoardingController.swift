//
//  ViewController.swift
//  kjkii
//
//  Created by abbas on 7/25/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import FSPagerView
import StoreKit
import ProgressHUD
class OnBoardingController: BaseViewController {
    
    @IBOutlet weak var pagerView    : FSPagerView!
    @IBOutlet weak var pageControl  : FSPageControl!
    @IBOutlet weak var btnSkip      : APButton!
    var onBoardingList              = [OnBoardingImages]()
    
    var currentCell:Int = 0 {
        didSet {
            pageControl.currentPage = self.currentCell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getOnboardingImages()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        pagerSetup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagerSetup()
    }
    
    @IBAction func btnSkipPressed(_ sender: Any) {
    }
    
    func getOnboardingImages(){
        ProgressHUD.show()
        let url = EndPoints.BASE_URL + "intro-images"
        let param = ["":""]
        getWebCallWithOutTokenWithCodeAble(url: url, params: param, webCallName: "", sender: self) { (response, error) in
            ProgressHUD.dismiss()
            if !error{
                
                let data = response.data(using: .utf8)!
                do
                {
                    self.onBoardingList.removeAll()
                    let response = try JSONDecoder().decode(OnBoardingStruct.self, from: data)
                    if let  imagess = response.images {
                        self.onBoardingList = imagess
                        self.pagerView.reloadData()
                    }
                    
                    else{
                        self.alert(message: "competition is not excist")
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

extension OnBoardingController:FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return onBoardingList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BPCell", at: index) as! BoardingPagerCell
        //let data = OnBoardingStrings.pages[index]
//        cell.setData(imgName: data[0], title: data[1], details1: data[2], details2: data[3])
       
        cell.setDateFromcall(item: onBoardingList[index])
        cell.imgView.contentMode = .scaleAspectFill
        return cell
    }
}

extension OnBoardingController:FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
    }
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView){print(
        "WillBeginDrag") }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.currentCell = targetIndex
        print("WillEndDrag")
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        if pagerView.currentIndex != currentCell {
            currentCell = pagerView.currentIndex
        };print("DidEndDecelerating: \(pagerView.currentIndex)")
    }
}

fileprivate extension OnBoardingController {
    func pagerSetup() {
        var size = pagerView.frame.size
//        size.width = Theme.screenWidth()
        let screenSize: CGRect = UIScreen.main.bounds
        size.width = screenSize.width
        pagerView.itemSize = size
    }
    
    func initialSetup() {
        IAPService.shared.getProducts()
        btnSkip.customize(font: .font20, .bold, .grayText, for: .normal)
        pagerSetup()
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.register(UINib(nibName: "BoardingPagerCell", bundle: .main), forCellWithReuseIdentifier: "BPCell")
        pagerView.interitemSpacing = 0
//        pagerView.transformer = FSPagerViewTransformer(type: .coverFlow)
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        pageControl.numberOfPages   = 4
        pageControl.currentPage     = 0
        pageControl.contentHorizontalAlignment = .left
        pageControl.setStrokeColor(Theme.Colors.disabled, for: .normal)
        pageControl.setStrokeColor(Theme.Colors.redText, for: .selected)
        pageControl.setFillColor(Theme.Colors.disabled, for: .normal)
        pageControl.setFillColor(Theme.Colors.redText, for: .selected)
        pageControl.itemSpacing = 10
        pageControl.interitemSpacing = 8
        
        //pageControl.setImage(UIImage(named: "control_not_selected"), for: .normal)
        //pageControl.setImage(UIImage(named: "control_selected"), for: .selected)
        //pageControl.itemSpacing = 22

        //FontManager.searchFont(keyWord:"Lato")
        /*
        let mView = UIView()
        mView.layer.cornerRadius = 10.0

        let maskPath = UIBezierPath(roundedRect: mView.bounds,
                                    byRoundingCorners: [.bottomLeft],
                                    cornerRadii: CGSize(width: 50.0, height: 0.0))

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        mView.layer.mask = maskLayer
        */
    }
}
