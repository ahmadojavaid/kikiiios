//
//  SubscriptioVC.swift
//  kjkii
//
//  Created by Saeed Rehman on 07/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit
import FSPagerView
import StoreKit
class SubscriptioVC: UIViewController {
    var priceOneMonth = ""

   
    @IBOutlet weak var pageControl: FSPageControl!
    
    @IBOutlet weak var pagerBottom  : FSPagerView!
    @IBOutlet weak var pagerview     : FSPagerView!
    var currentCellTop:Int = 0 {
        didSet {
            pageControl.currentPage = self.currentCellTop
        }
    }
    var products: [SKProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.accountUpgrade(_:)), name: NSNotification.Name(rawValue: "AccountUpgraded"), object: nil)
        UIHelper.shared.popView(sender: self)
        InitiatlSetup()
        IAPService.shared.getProducts()
        PoohWisdomProducts.store.requestProducts { [weak self] success, products in
          guard let self = self else { return }
          guard success else {
//            let alertController = UIAlertController(title: "Failed to load list of products",
//                                                    message: "Check logs for details",
//                                                    preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alertController, animated: true, completion: nil)
            print("failed to load products")
            return
            
          }
          self.products = products!
            self.priceOneMonth = self.getPriceFormatted(for: products![0]) ?? "19 $"
            
            
        }
       
        // Do any additional setup after loading the view.
    }
    @objc func accountUpgrade(_ notification: NSNotification) {
        upgradeAccount()
    }
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        IAPService.shared.purchase(product: IAPProduct.buyAdFree)
        
//        guard !products.isEmpty else {
//          print("Cannot purchase subscription because products is empty!")
//          return
//        }
//        PoohWisdomProducts.store.buyProduct(products[0]) { [weak self] success, productId in
//          guard let self = self else { return }
//          guard success else {
//            let alertController = UIAlertController(title: "Failed to purchase product",
//                                                    message: "Check logs for details",
//                                                    preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alertController, animated: true, completion: nil)
//            return
//          }
//          print("purchased")
//        }
        
        
    }
    func InitiatlSetup(){
        pagerview.delegate      = self
        pagerview.dataSource    = self
        pagerview.interitemSpacing = 0
        pagerBottom.delegate    = self
        pagerBottom.dataSource  = self
        pagerview.register(UINib(nibName: "SubscriptionPagerCell", bundle: .main), forCellWithReuseIdentifier: "PTCell")
        pagerBottom.register(UINib(nibName: "SubscriptionCell", bundle: .main), forCellWithReuseIdentifier: "SubscriptionCell")
        pageControl.numberOfPages = 10
        pageControl.currentPage = 0
        pageControl.contentHorizontalAlignment = .center
        pageControl.setStrokeColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), for: .normal)
        pageControl.setStrokeColor(Theme.Colors.whiteText, for: .selected)
        pageControl.setFillColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), for: .normal)
        pageControl.setFillColor(Theme.Colors.whiteText, for: .selected)
        pageControl.itemSpacing = 10
        pageControl.interitemSpacing = 8
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pagerSetup()
    }
    func pagerSetup() {
       
        var size2 = CGSize(width: view.frame.size.width * 140/375, height: 0)
        size2.height = size2.width * 161/140
        pagerBottom.itemSize = size2
    }
    
    
    @IBAction func noThanksBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func upgradeAccount(){
        let url = BASE_URL + "upgrade"
//        let url = "https://kikii.uk/api/update/profile"
        let params =
            [        "upgraded": "1"
                     
            ]
        
        print(params)
        postWebCall(url: url, params: params, webCallName: "upgrade account") { (response, error)  in
            if !error{
//                DispatchQueue.main.async {
//                   print("Account upgraded")
                DEFAULTS.setValue("1", forKey: PurchasedStates.purchased)
                oneStepBackPopUp(msg: "Account has been upgraded", sender: self)
                }
                else{
                   print("")
                    self.alert(message: API_ERROR)
                }
        
            
    
    }
    }
    
    
    
}
extension SubscriptioVC: FSPagerViewDelegate,FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == self.pagerview{
            return 10
        }else{
            return 1
        }
        
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if pagerView == self.pagerview {
            self.currentCellTop = targetIndex
            print(targetIndex)
            return
        }
        
        func SubscriptioVC(_ pagerView: FSPagerView) {
            if pagerView == self.pagerview {
                if pagerView.currentIndex != currentCellTop {
                    self.currentCellTop = pagerView.currentIndex
                }
                return
            }
            
        }
        
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == self.pagerview{
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "PTCell", at: index)
            return cell
        }else{
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", at: index) as! SubscriptionCell
            cell.lblRupee.text = "$19.99"
            
            return cell
        }
        
    }
    
    
}
