//
//  CommunityCell.swift
//  kjkii
//
//  Created by Shahbaz on 06/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class CommunityCell: UITableViewCell {
    
    @IBOutlet weak var commentBtnView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var showAllImages: UIButton!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var commentText: APLabel!
    @IBOutlet weak var userName: APLabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeLabel: APLabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likesCount: APLabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var commentCount: APLabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    
    func config(item: Posts){
        userName.text = item.user?.name
        commentText.text = item.body
        timeLabel.text = item.created_at //timeInterval(timeAgo: arr)
        if let user = item.user{
            UIHelper.shared.setImage(address: user.profile_pic ?? "", imgView: userImage)
        }
        if let media = item.media{
            setMedia(media_item: media)
        }
        likesCount.text         = "\(item.likes_count ?? 0)"
        commentCount.text       = "\(item.comments_count ?? 0)"
        if item.IsLiked ?? 0    == 1 {
            likeImg.image = UIImage(named: "like")
        } else{
            likeImg.image = UIImage(named: "unlike")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func setMedia(media_item: [Media]){
        
        let width = containerView.frame.width
        let size = CGSize(width: width, height: 272)
        for v in containerView.subviews
        {
            v.removeFromSuperview()
        }
        if media_item.count == 0
        {
            containerHeight.constant = 0.0
            showAllImages.isHidden = true
        } else if media_item.count == 1{
            showAllImages.isHidden = false
            let myView1 = Bundle.main.loadNibNamed("oneIamgeView", owner: self, options: nil)?[0] as! oneIamgeView
            UIHelper.shared.setImage(address: "\(media_item[0].path ?? "")", imgView: myView1.img_view)
            containerHeight.constant = 272
            myView1.bounds.size = size
            myView1.frame = containerView.bounds
            myView1.img_view.contentMode = .scaleAspectFit
            containerView.addSubview(myView1)
        } else if media_item.count == 2{
            showAllImages.isHidden = false
            
            let myView2 = Bundle.main.loadNibNamed("TwoImegesVC", owner: self, options: nil)?[0] as! TwoImegesVC
            UIHelper.shared.setImage(address: "\(media_item[0].path ?? "")", imgView: myView2.img2)
            
            UIHelper.shared.setImage(address: "\(media_item[1].path ?? "")", imgView: myView2.img1)
            
            containerHeight.constant = 272
            myView2.bounds.size = size
            myView2.frame = containerView.bounds
            containerView.addSubview(myView2)
        } else if media_item.count == 3{
            showAllImages.isHidden = false
            let myView2 = Bundle.main.loadNibNamed("ThreeImagesVC", owner: self, options: nil)?[0] as! ThreeImagesVC
            UIHelper.shared.setImage(address: "\(media_item[0].path ?? "")", imgView: myView2.img2)
            UIHelper.shared.setImage(address: "\(media_item[1].path ?? "")", imgView: myView2.img1)
            
            UIHelper.shared.setImage(address: "\(media_item[2].path ?? "")", imgView: myView2.img3)
            myView2.more_container.isHidden = true
            containerHeight.constant = 260
            myView2.frame.size = size
            myView2.frame = containerView.bounds
            containerView.addSubview(myView2)
        }
        else if media_item.count > 3{
            showAllImages.isHidden = false
            
            let myView2 = Bundle.main.loadNibNamed("ThreeImagesVC", owner: self, options: nil)?[0] as! ThreeImagesVC
            UIHelper.shared.setImage(address: "\(media_item[0].path ?? "")", imgView: myView2.img2)
            UIHelper.shared.setImage(address: "\(media_item[1].path ?? "")", imgView: myView2.img1)
            UIHelper.shared.setImage(address: "\(media_item[2].path ?? "")", imgView: myView2.img3)
            myView2.more_container.isHidden = false
            //myView2.counter_label.text = "\(media_item.count - 3)"
            containerHeight.constant = 272
            myView2.bounds.size = size
            myView2.frame = containerView.bounds
            containerView.addSubview(myView2)
        }
        
    }
    
}
