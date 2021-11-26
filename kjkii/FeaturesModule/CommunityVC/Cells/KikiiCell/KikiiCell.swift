//
//  KikiiCell.swift
//  kjkii
//
//  Created by Shahbaz on 06/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class KikiiCell: UITableViewCell {
    @IBOutlet weak var countViewHeight  : NSLayoutConstraint!
    @IBOutlet weak var countView        : UIView!
    @IBOutlet weak var likeImage        : UIImageView!
    @IBOutlet weak var likeCount        : APLabel!
    @IBOutlet weak var commentCount     : APLabel!
    @IBOutlet weak var userName         : APLabel!
    @IBOutlet weak var timeLabel        : APLabel!
    @IBOutlet weak var postBody         : APLabel!
    @IBOutlet weak var commentBtn       : UIButton!
    @IBOutlet weak var likeBtn          : UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    func configCell(item: KiPosts){
        userName.text = item.user?.name
        postBody.text = item.body
        if item.isLiked ?? 0 == 1{
            likeImage.image = UIImage(systemName: "heart.fill")
        }
        else{
            likeImage.image = UIImage(systemName: "heart")
        }
        likeCount.text = "\(item.likes_count ?? 0)"
        commentCount.text = "\(item.comments_count ?? 0)"
    }
    
}
