//
//  BaseViewController.swift
//  Movies
//
//  Created by Sarmad on 2/17/19.
//  Copyright © 2019 Sarmad Abbas. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class BaseViewController: UIViewController {
    private var progressView:UIView?
    private var toastViews = [UIView]()
    private let baseManager = BaseManager()

    // MARK: - ViewController Methods
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidConnect(_:)), name: NSNotification.Name.NetworkDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidDisconnect(_:)), name: NSNotification.Name.NetworkDidDisconnect, object: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NetworkDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NetworkDidDisconnect, object: nil)
    }
    
    // MARK: - Uitlity Methods
    
    @objc func setupUI() {
        customeNavigationBar()
    }
    
    func setData() {
        
    }
    
    func didChangeNetwork(status: NetworkStatus) {
        
    }
    
    func showToast(_ message: String, type toastType: ToastType) {
        //let topRef:CGFloat = CGFloat(5 * toastViews.count)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        containerView.backgroundColor = toastType.color
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.font = Theme.Font.ofSize(.font16, weight: .regular)
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(messageLabel)
        view.addSubview(containerView)
        toastViews.append(containerView)
        
        let messageLabelConstraints = [
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor ,constant: -10),
            messageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Theme.adjustRatio(16)),
            messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -Theme.adjustRatio(16)),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        NSLayoutConstraint.activate(messageLabelConstraints)
        UIView.animate(withDuration: 0.01, animations: {
            messageLabelConstraints[4].constant = 0
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.4, animations: {
                messageLabelConstraints[4].constant = containerView.frame.size.height * CGFloat(self.toastViews.count)
                self.view.layoutIfNeeded()
            }) { _ in
                UIView.animate(withDuration: 0.4, delay: 5, animations: {
                    messageLabelConstraints[4].constant = 0 //-containerView.frame.size.height
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    containerView.removeFromSuperview()
                    if let index = self.toastViews.index(of: containerView) {
                        self.toastViews.remove(at: index)
                    }
                })
            }
        }
    }
    
    
}

extension BaseViewController {
    @objc private func networkDidConnect(_ sender: Notification) {
        didChangeNetwork(status: .connected)
    }
    @objc private func networkDidDisconnect(_ sender: Notification) {
        didChangeNetwork(status: .disconnected)
    }
    
    func customeNavigationBar() {
        
        let atrib = [NSAttributedString.Key.font: Theme.Font.ofSize(.font18, weight: .semiBold), NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(atrib, for: UIControl.State.normal)
        
        self.navigationController?.navigationBar.barTintColor = Theme.Colors.tint
        //self.navigationController?.navigationBar.addShadow(height: 4.0)
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Theme.Font.ofSize(.font18, weight: .semiBold), NSAttributedString.Key.foregroundColor: UIColor.white]
        //bt.semanticContentAttribute =
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            customBarBackButton()
        }
        self.navigationController?.navigationBar.addShadow(yOffset: 1, shadowColor: UIColor.black.cgColor)
        //            self.hideNavigatinBarBackButtonTitle()
    }
    
    func customBarBackButton() {
        let bt = UIButton()
        bt.setImage(UIImage(named: "btn_back"), for: .normal)
        //let aTitle = NSAttributedString(string: "btn", attributes: [NSAttributedString.Key.foregroundColor : UIColor.clear])
        //bt.setAttributedTitle(aTitle, for: .normal)
        bt.tintColor = Theme.Colors.tint
        bt.addTarget(self, action: #selector(navigationAction), for: .touchUpInside)
        let btn = UIBarButtonItem()
        btn.customView = bt
        btn.tintColor = Theme.Colors.tint
        navigationItem.leftBarButtonItem = btn
    }
    @objc func navigationAction (){
        self.navigationController?.popViewController(animated: true)
    }
    
    func customBarLeftButton(imageName:String, selector:Selector) {
        let bt = UIButton()
        bt.tintColor = Theme.Colors.tint
        bt.setImage(UIImage(named: imageName), for: .normal)
        bt.addTarget(self, action: selector, for: .touchUpInside)
        let btn = UIBarButtonItem()
        btn.customView = bt
        navigationItem.leftBarButtonItem = btn
    }
    
    func customBarRightButton(imageName:String, selector:Selector) {
        let bt = UIButton()
        bt.tintColor = Theme.Colors.tint
        bt.setImage(UIImage(named: imageName), for: .normal)
        bt.addTarget(self, action: selector, for: .touchUpInside)
        bt.tintColor = Theme.Colors.tint
        let btn = UIBarButtonItem()
        btn.customView = bt
        navigationItem.rightBarButtonItem = btn
    }
    
    func getCustomeBaarButton(imageName:String, selector:Selector, tag:Int = 0) -> UIBarButtonItem {
        let bt = UIButton()
        bt.tintColor = Theme.Colors.tint
        bt.setImage(UIImage(named: imageName), for: .normal)
        //let aTitle = NSAttributedString(string: "btn", attributes: [NSAttributedString.Key.foregroundColor : UIColor.clear])
        //bt.setAttributedTitle(aTitle, for: .normal)
        bt.addTarget(self, action: selector, for: .touchUpInside)
        let btn = UIBarButtonItem()
        btn.customView = bt
        btn.tag = tag
        return btn
    }
    
    func UserIsLoggedIn(animate:Bool = false){
        if User.isLogedIn != true {
            //let vc = LogInSignUpViewController(nibName: "LogInSignUpViewController", bundle: .main)
            //vc.modalTransitionStyle = .flipHorizontal
            //vc.modalPresentationStyle = .fullScreen
            //vc.selectedTab = .login
            //self.present(vc, animated: true, completion: nil)
            //let profile_vc = tabBarController?.viewControllers?[3]
            //profile_vc?.navigationController?.pushViewController(vc, animated: false)
            //tabBarController?.selectedIndex = 3
            //vc.hidesBottomBarWhenPushed = true
            //self.navigationController?.pushViewController(vc, animated: animate)
        }
    }
    func addPayment(){
        self.tabBarController?.selectedIndex = 3
    }
    
    func shwoProgress() {
        progressView = UIView(frame: view.frame)
        progressView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let label = UILabel()
        progressView?.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        progressView?.addSubview(label)
        view.addSubview(progressView!)
        label.text = "Please wait..."
        label.textAlignment = .center
        label.backgroundColor = .clear
        let constraints = [
            progressView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            progressView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            progressView!.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            label.centerYAnchor.constraint(equalTo: progressView!.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: progressView!.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    func dismissProgress() {
        progressView?.removeFromSuperview()
    }
}

// APIs Implementation

extension BaseViewController {
    func getJSON(_ endPoint:String, completion:@escaping (APIResponseStatus, JSON?)->Void){
        // SVProgressHUD.show()
        // self.showProgressHud(message: "Please Wait...")
        shwoProgress()
        baseManager.getRequest(endPoint, parms: nil, header: nil) { (status, data) in
            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
            self.dismissProgress()
            // self.dismissProgressHud()
            // SVProgressHUD.dismiss()
            //self.dismissProgress(vc)
            guard status.isSuccess, let data = data else {
                let aStatus = APIResponseStatus(isSuccess: false, code: status.code, message: status.message)
                completion(aStatus, nil)
                return
            }
            guard let json = try? JSON(data: data) else {
                completion(APIResponseStatus.invalidResponse, nil)
                return
            }
            var msg = json["statusMessage"].stringValue
            if msg.contains("Validation") == true {
                let vm = self.processValidationMessages(dataMsgs: json["data"])
                msg = (vm.count > 5) ? (msg + "\n" + vm):msg
            }
            if json["message"].stringValue.contains("Unauthenticated") {
                completion(APIResponseStatus.unauthenticated, nil)
                return
            }
            if msg.trimmed.count == 0 {
                msg = "Invalid Response"
            }
            let code = json["statusCode"].intValue
            let jsonData = json["data"]
            completion(APIResponseStatus(isSuccess: code == 1, code: code, message: msg), jsonData)
        }
    }
    
    func postRequestJSON(endPoint:String,parms:[String:Any]? ,completion:@escaping (APIResponseStatus, JSON?)->Void) {
        
        // SVProgressHUD.show()
        // self.showProgressHud(message: "Please Wait...")
        //let vc = showProgress("Please Wait...")
        shwoProgress()
        baseManager.postRequest(endPoint, parms: parms, header: nil) { (status, data) in
            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
            self.dismissProgress()
            // // self.dismissProgressHud()
            // SVProgressHUD.dismiss()
            //self.dismissProgress(vc)
            guard status.isSuccess, let data = data else {
                let aStatus = APIResponseStatus(isSuccess: false, code: status.code, message: status.message)
                completion(aStatus, nil)
                return
            }
            guard let json = try? JSON(data: data) else {
                completion(APIResponseStatus.invalidResponse, nil)
                return
            }
            var msg = json["statusMessage"].stringValue
            if msg.contains("Validation") == true || msg.contains("Error") == true{
                let vm = self.processValidationMessages(dataMsgs: json["data"])
                msg = (vm.count > 5) ? (vm):msg
            }
            if json["message"].stringValue.contains("Unauthenticated") {
                completion(APIResponseStatus.unauthenticated, nil)
                return
            }
            if msg.trimmed.count == 0 {
                msg = "Invalid Response"
            }
            let code = json["statusCode"].intValue
            let jsonResult = json["data"]
            completion(APIResponseStatus(isSuccess: code == 1, code: code, message: msg), jsonResult)
        }
    }
    
    func getJSONAuth(_ endPoint:String, showProgress:Bool = true  ,completion:@escaping (APIResponseStatus, JSON?)->Void) {
        // SVProgressHUD.show()
        // self.showProgressHud(message: "Please Wait...")
        // let vc = showProgress("Please Wait...")
        if showProgress {
            shwoProgress()
        }
        baseManager.getRequestWithAuth(endPoint) { (status, data) in
            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
            if showProgress{
                self.dismissProgress()
            }
                // // self.dismissProgressHud()
            // SVProgressHUD.dismiss()
            //self.dismissProgress(vc)
            guard status.isSuccess, let data = data else {
                let aStatus = APIResponseStatus(isSuccess: false, code: status.code, message: status.message)
                completion(aStatus, nil)
                return
            }
            guard let json = try? JSON(data: data) else {
                completion(APIResponseStatus.invalidResponse, nil)
                return
            }
            var msg = json["statusMessage"].stringValue
            if msg.contains("Validation") == true {
                let vm = self.processValidationMessages(dataMsgs: json["data"])
                msg = (vm.count > 5) ? (msg + "\n" + vm):msg
            }
            if json["message"].stringValue.contains("Unauthenticated") {
                completion(APIResponseStatus.unauthenticated, nil)
                return
            }
            if msg.trimmed.count == 0 {
                msg = "Invalid Response"
            }
            let code = json["statusCode"].intValue
            // Special For Shiraz . . .
            var jsonData = json["data"]
            let sDate = json["SemesterStartDate"].stringValue
            //let eDate = json["SemesterEndDate"].stringValue
            if sDate != "" {
                jsonData = json
            }
            // End of Special for Shiraz . . .
            //let jsonData = JSON(jsonDict)
            completion(APIResponseStatus(isSuccess: code == 1, code: code, message: msg), jsonData)
        }
    }
    
    func postRequestJSONAuth(_ endPoint:String,parms:[String:Any]?, completion:@escaping (APIResponseStatus, JSON?)->Void){
        // SVProgressHUD.show()
        // self.showProgressHud(message: "Please Wait...")
        //let vc = showProgress("Please Wait...")
        shwoProgress()
        baseManager.postRequestWithAuth(endPoint, parameters: parms) { (status
            , data) in
            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
            self.dismissProgress()
            // // self.dismissProgressHud()
            // SVProgressHUD.dismiss()
            //self.dismissProgress(vc)
            guard status.isSuccess, let data = data else {
                let aStatus = APIResponseStatus(isSuccess: false, code: status.code, message: status.message)
                completion(aStatus, nil)
                return
            }
            guard let json = try? JSON(data: data) else {
                completion(APIResponseStatus.invalidResponse, nil)
                return
            }
            var msg = json["statusMessage"].stringValue
            if msg.contains("Validation") == true {
                let vm = self.processValidationMessages(dataMsgs: json["data"])
                msg = (vm.count > 5) ? (msg + "\n" + vm):msg
            }
            if json["message"].stringValue.contains("Unauthenticated") {
                completion(APIResponseStatus.unauthenticated, nil)
                return
            }
            if msg.trimmed.count == 0 {
                msg = "Invalid Response"
            }
            let code = json["statusCode"].intValue
            let jsonData = json["data"]
            completion(APIResponseStatus(isSuccess: code == 1, code: code, message: msg), jsonData)
        }
    }
    
    func processValidationMessages(dataMsgs:JSON) -> String {
        /*
         let messages = Array(dataMsgs.dictionaryValue.values).map { (json) -> String in
         let msg = json.arrayValue[0].stringValue
         return msg
         } */
        let messages = dataMsgs.dictionaryValue
        var message = ""
        
        messages.forEach { (msg) in
            let msgArray = msg.value.arrayValue
            if msgArray.count > 0 {
                message = message + (message.count > 1 ? "\n":"") + msgArray[0].stringValue
            }
        }
        
        return message
    }
    /*
    func isLocationAccess() -> Bool {
        let alert = UIAlertController(title: "Allow \"Polse\" to Access your location?", message: "Location is used to check you in for your class attendence. Go to settings to grant location access", preferredStyle: .alert)
        let actionO = UIAlertAction(title: "Settings", style: .default) { action in
            if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
                let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            //if let url = URL(string: "App-prefs:root=LOCATION_SERVICES") {
            //    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //}
        }
        let actionC = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionC)
        alert.addAction(actionO)
        
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            AppDelegate.shared?.getLocation()
            return true
        case .notDetermined:
            AppDelegate.shared?.getLocation()
            return false
        case .denied, .restricted:
            self.present(alert, animated: true, completion: nil)
            return false
        default:
            return true
        }
    }
    */
}

