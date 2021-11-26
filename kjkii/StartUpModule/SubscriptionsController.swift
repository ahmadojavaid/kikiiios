//
//  SubscriptionsController.swift
//  kjkii
//
//  Created by abbas on 7/28/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import FSPagerView
import StoreKit
class SubscriptionsController: UIViewController {
    
    @IBOutlet weak var pagerViewTop : FSPagerView!
    @IBOutlet weak var pageControl  : FSPageControl!
    @IBOutlet weak var pagerVIewBot : FSPagerView!
    var currentCellTop:Int = 0 {
        didSet {
            pageControl.currentPage = self.currentCellTop
        }
    }
    
    var currentCellBot:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        //print( IAPService.shared.getProducts())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pagerSetup()
    }
    
    @IBAction func btnNextPressed(_ sender: Any) {
        IAPService.shared.getProducts()
        IAPService.shared.purchase(product: IAPProduct.buyAdFree)
        
    }
    
    @IBAction func btnNoThanksPressed(_ sender: Any) {
        NewAppPurchase.sharedInstance.buyNonrenewingSubscription()
        
    }
}

extension SubscriptionsController:FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == self.pagerViewTop {
            return 8
        }else{
            return 1
        }
        
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == self.pagerViewTop {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "PTCell", at: index)
            return cell
        }
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", at: index) as! SubscriptionCell
        cell.setData(currencyType: "PKR", ammount: 2470, type: .OneMonth)
        //        switch index {
        //        case 0:
        //            cell.setData(currencyType: "PKR", ammount: 2470, type: .OneMonth)
        //        case 1:
        //            cell.setData(currencyType: "PKR", ammount: 11857, type: .OneYearPop)
        //        default:
        //            cell.setData(currencyType: "PKR", ammount: 14822, type: .OneYear)
        //        }
        return cell
    }
}

extension SubscriptionsController:FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if pagerView == self.pagerViewTop {
            self.currentCellTop = targetIndex
            return
        }
        self.currentCellBot = targetIndex
    }
    
    func SubscriptionsController(_ pagerView: FSPagerView) {
        if pagerView == self.pagerViewTop {
            if pagerView.currentIndex != currentCellTop {
                self.currentCellTop = pagerView.currentIndex
            }
            return
        }
        
        if pagerView.currentIndex != currentCellBot {
            self.currentCellBot = pagerView.currentIndex
        }
    }
}

fileprivate extension SubscriptionsController {
    func pagerSetup() {
        let size = pagerViewTop.frame.size
        pagerViewTop.itemSize = size
        
        var size2 = CGSize(width: view.frame.size.width * 140/375, height: 0)
        size2.height = size2.width * 161/140
        pagerVIewBot.itemSize = size2
    }
    
    func initialSetup() {
        
        IAPService.shared.getProducts()
        pagerViewTop.delegate = self
        pagerViewTop.dataSource = self
        pagerViewTop.interitemSpacing = 0
        pagerViewTop.register(UINib(nibName: "SubscriptionPagerCell", bundle: .main), forCellWithReuseIdentifier: "PTCell")
        
        pagerVIewBot.delegate = self
        pagerVIewBot.dataSource = self
        pagerVIewBot.interitemSpacing = 5
        //pagerVIewBot.transformer = FSPagerViewTransformer(type: .linear)
        pagerVIewBot.register(UINib(nibName: "SubscriptionCell", bundle: .main), forCellWithReuseIdentifier: "SubscriptionCell")
        
        pageControl.numberOfPages = 8
        pageControl.currentPage = 0
        pageControl.contentHorizontalAlignment = .center
        pageControl.setStrokeColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), for: .normal)
        pageControl.setStrokeColor(Theme.Colors.whiteText, for: .selected)
        pageControl.setFillColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), for: .normal)
        pageControl.setFillColor(Theme.Colors.whiteText, for: .selected)
        pageControl.itemSpacing = 10
        pageControl.interitemSpacing = 8
    }
}
//extension  SubscriptionsController:SKProductsRequestDelegate, SKPaymentTransactionObserver
//{
//    func buyInApp()
//    {
//        if (SKPaymentQueue.canMakePayments())
//        {
//            let productID:NSSet = NSSet(object: "com.jobesk.kikiiApp.Subscription");
//            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
//            productsRequest.delegate = self;
//            productsRequest.start();
//        }
//        else
//        {
//            //MBProgressHUD.hideHUDForView(self.view, animated: true)
//        }
//    }
//
//    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse)
//    {
//        let count : Int = response.products.count
//        if (count>0)
//        {
//            let validProduct: SKProduct = response.products[0] as SKProduct
//
//            if (validProduct.productIdentifier == "com.jobesk.kikiiApp.Subscription")
//            {
//                buyProduct(product: validProduct);
//            }
//            else
//            {
//                //MBProgressHUD.hideHUDForView(self.view, animated: true)
//            }
//        }
//        else
//        {
//            //MBProgressHUD.hideHUDForView(self.view, animated: true)
//        }
//    }
//
//    func buyProduct(product: SKProduct)
//    {
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//        //SKPaymentQueue.defaultQueue().addTransactionObserver(self)
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
//    {
//        for transaction:AnyObject in transactions
//        {
//            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction
//            {
//                switch trans.transactionState
//                {
//                case .purchased:
//                    
//                   // self.PaymentSuccess("Apple", details: "Apple(In-App)")
//                    print("In App Payment Success")
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    //MBProgressHUD.hideHUDForView(self.view, animated: true)
//                    break
//                case .failed:
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//
//                    let alert = UIAlertController(title: "Planes Only", message: "Payment failed", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
//                    }))
//                    self.present(alert, animated: true, completion: nil)
////                    self.presentViewController(alert, animated: true, completion: nil)
//
//                    break
//                case .restored :
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    //MBProgressHUD.hideHUDForView(self.view, animated: true)
//                    break
//                default:
//                    //MBProgressHUD.hideHUDForView(self.view, animated: true)
//                    break
//                }
//            }
//        }
//    }
//
//    func restore()
//    {
//        SKPaymentQueue.default().add(self)
//        SKPaymentQueue.default().restoreCompletedTransactions()
//        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//    }
//
//    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue)
//    {
//        for transact:SKPaymentTransaction in queue.transactions
//        {
//            if transact.transactionState == SKPaymentTransactionState.restored
//            {
//                //let t: SKPaymentTransaction = transact as SKPaymentTransaction
//                //let prodID = t.payment.productIdentifier as String
//                //restore prodID
//                SKPaymentQueue .default().finishTransaction(transact)
//                //MBProgressHUD.hideHUDForView(self.view, animated: true)
//            }
//        }
//    }
//
//    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError)
//    {
//        for transaction:SKPaymentTransaction  in queue.transactions
//        {
//            if transaction.transactionState == SKPaymentTransactionState.restored
//            {
//                SKPaymentQueue.default().finishTransaction(transaction)
//                //MBProgressHUD.hideHUDForView(self.view, animated: true)
//                break
//            }
//        }
//        //MBProgressHUD.hideHUDForView(self.view, animated: true)
//    }
//
//    func request(request: SKRequest, didFailWithError error: NSError)
//    {
//        //MBProgressHUD.hideHUDForView(self.view, animated: true)
//    }
//}
