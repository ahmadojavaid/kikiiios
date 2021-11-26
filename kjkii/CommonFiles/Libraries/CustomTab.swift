import UIKit
class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateToken()
        self.tabBar.layer.masksToBounds     = true
        self.tabBar.isTranslucent           = true
        self.tabBar.layer.cornerRadius      = 20
        self.tabBar.layer.maskedCorners     = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.layer.borderWidth       = 1
        self.tabBar.layer.borderColor       = UIColor(named: "appRed")!.cgColor
        view.bringSubviewToFront(tabBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onePost(_:)), name: NSNotification.Name("onePost"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(oneFriend(_:)), name: NSNotification.Name("oneFriend"), object: nil)
        
        
    }
    func updateToken(){
        Common.shared.updateToken(token: appDelegate.firebaseToken,lastLogin: "") { (done) in
            if done{
                print("token has been updated")
            }
        }
    }
    
    @objc func onePost(_ sender: Notification){
        if let dict = sender.userInfo as NSDictionary? {
            if let id = dict["user_id"] as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityVC") as! CommunityVC
                vc.user_id = id
                vc.postTypes = .otherPosts
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    @objc func oneFriend(_ sender: Notification){
        if let dict = sender.userInfo as NSDictionary? {
            if let id = dict["user_id"] as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendsController") as! FriendsController
                vc.user_id  = id
                vc.postType = .otherPosts
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}




class RoundShadowView: UIView {
    
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -8.0)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10.0
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}


extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

