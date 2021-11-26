//
//  UIHelper.swift
//  E-Echos
//
//  Created by Shahbaz on 04/06/2020.
//  Copyright © 2020 Shahbaz. All rights reserved.
//

import UIKit
import Nuke
struct UIHelper {
    init() {}
    
    static let shared = UIHelper()
    func popView(sender: UIViewController)
    {
        sender.navigationController?.interactivePopGestureRecognizer?.delegate = sender as? UIGestureRecognizerDelegate
        sender.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    func disablePop(sender: UIViewController)
    {
        sender.navigationController?.interactivePopGestureRecognizer?.delegate = sender as? UIGestureRecognizerDelegate
        sender.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setupTable(nibName: String, tbl: UITableView)
    {
        tbl.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
        tbl.backgroundView                      = .none
        tbl.backgroundColor                     = .clear
        tbl.estimatedRowHeight                  = 100
        tbl.rowHeight                           = UITableView.automaticDimension
        tbl.separatorStyle                      = .none
        tbl.showsVerticalScrollIndicator        = false
        tbl.showsHorizontalScrollIndicator      = false
    }
    func setCell(cell: UITableViewCell){
        cell.backgroundView                     = .none
        cell.backgroundColor                    = .clear
        cell.selectionStyle                     = .none
    }
    
    func statuBarHeight(sender: UIViewController, viewHeightConstraint: NSLayoutConstraint)
    {
        let height                              = UIApplication.shared.statusBarFrame.size.height
        viewHeightConstraint.constant           = height
    }
    
    func saveUserData(user: PhoneUser)
    {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedPerson")
        }
    }
    
    func setImage(address: String, imgView: UIImageView){
        let userPlaceHolder = ImageLoadingOptions(
            placeholder: UIImage(named: "imgpager"),
            failureImage: UIImage(named: "imgpager"),
            contentModes: .init(success: .scaleAspectFill, failure: .scaleAspectFill, placeholder: .scaleAspectFill)
        )
        if let url = URL(string: address){
            Nuke.loadImage(with: url, options: userPlaceHolder, into: imgView)
//            imgView.sd_setImage(with: url, completed: nil)
        }
        else
        {
            Nuke.loadImage(with: URL(string: "URL")!, options: userPlaceHolder, into: imgView)
        }
    }
    func addBanners(container:UIView, sender: UIViewController)
    {
        let header = Banners(nibName: "Banners", bundle: nil)
        header.view.frame = container.bounds
        container.addSubview(header.view)
        sender.addChild(header)
        //popView(sender: sender)
    }
    func yearsBetweenDate(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: startDate, to: endDate)
        return components.year!
    }
}





// create another struct like this..
struct CurrentUser {
    static public func userData() -> PhoneUser?{
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data
        {
            let decoder = JSONDecoder()
            let loadedPerson = try? decoder.decode(PhoneUser.self, from: savedPerson)
            return loadedPerson
        }
        else
        {
            return nil
        }
    }
}


