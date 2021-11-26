//
//  MatchClcCell.swift
//  kjkii
//
//  Created by Shahbaz on 05/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class MatchClcCell: UICollectionViewCell {
    @IBOutlet weak var containerView    : UIView!
    @IBOutlet weak var imgView          : UIImageView!
    @IBOutlet weak var userName         : APLabel!
    @IBOutlet weak var mintLabel        : APLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius    = 30
        imgView.layer.cornerRadius          = 20
        imgView.layer.masksToBounds         = true
    }
    func configCell(item: Matches) {
        userName.text = item.name
        UIHelper.shared.setImage(address: item.profile_pic ?? "", imgView: imgView)
        mintLabel.text = item.last_online
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
//        let date = dateFormatter.date(from: item.last_online ?? "")
//        let years           = UIHelper.shared.yearsBetweenDate(startDate: date, endDate: Date())
//        print("*************")
//        print(years)
    }
    
    func timeInterval(timeAgo:String) -> String
    {
        let df = DateFormatter()
        var dateFormat = ""
        if timeAgo.contains(":")
        {
            dateFormat = "E, d MMM yyyy HH:mm:ss"
        }
        else if timeAgo.contains("/")
        {
            dateFormat = "dd/MM/yyyy"
        }
        df.dateFormat = dateFormat
        let dateWithTime = df.date(from: timeAgo)
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime!, to: Date())
        if let year = interval.year, year > 0
        {
            return year == 1 ? "\(year)" + " " + "year ago" : "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" : "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" : "\(day)" + " " + "days ago"
        }else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" : "\(hour)" + " " + "hours ago"
        }else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute ago" : "\(minute)" + " " + "minutes ago"
        }else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second ago" : "\(second)" + " " + "seconds ago"
        } else {
            return "a moment ago"
        }
    }
}









extension UIView{
    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
    }
}
