//
//  FilterVC.swift
//  kjkii
//
//  Created by Shahbaz on 28/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import RangeSeekSlider
import TCPickerView


class FilterVC: UIViewController, RangeSeekSliderDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, TCPickerViewOutput{
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
        print("")
    }
    
    
    @IBOutlet weak var distanceSlider: UISlider!
    
    
    
    @IBOutlet var distanceLbls: [APLabel]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedHeight: APLabel!
    @IBOutlet weak var selectedDistanceLbl: APLabel!
    @IBOutlet weak var ageLbl: APLabel!
    @IBOutlet weak var ageSlider: RangeSeekSlider!
    var min = 18
    var max = 60
    var selectedMin: CGFloat = 18.0
    var selectedMax: CGFloat = 60.0
    private var cellSizes = [[CGSize]]()
    var userSelectedHeight = String()
    @IBOutlet var heightLbls: [UILabel]!
    var items = ["one","twooooooooo","dddddddddddd"]
    var filtersData: AvailableFilters?
    var selectedFilters: FetchSelectedFilters?
    var gotSelectedFilters: [String:Any]?
    var myNewDictArray = ["drink":"","smoke":"","gender_identity":"","sexual_identity":"","pronouns":"","relationship_status":"","looking_for":"","diet_like":"","cannabis":"","political_views":"","religion":"","sign":"","pets":"","kids":""]
    var myNewDictArrayReplica = ["drink":"","smoke":"","gender_identity":"","sexual_identity":"","pronouns":"","relationship_status":"","looking_for":"","diet_like":"","cannabis":"","political_views":"","religion":"","sign":"","pets":"","kids":""]
    var selectedFilterCell = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ageSlider.delegate = self
        getSelectedFilters()
        
        UIHelper.shared.disablePop(sender: self)
        
        distanceLbls.forEach({$0.textColor = UIColor(named: "grayText")})
        distanceLbls[0].textColor = UIColor(named: "appRed")
        heightLbls.forEach({$0.textColor = UIColor(named: "grayText")})
        heightLbls[0].textColor = UIColor(named: "appRed")
//        selectedHeight.text = ""
        userSelectedHeight = ""
        
       }
    override func viewDidAppear(_ animated: Bool) {
        registerTagCells()
        collectionView.delegate = self
        collectionView.dataSource = self
       }
    func registerTagCells(){
        //Register Tag Cell
        let nibName = UINib(nibName: TagCell.reuseIdentifierString, bundle:nil)
        collectionView!.register(nibName, forCellWithReuseIdentifier: TagCell.reuseIdentifierString)

        // Do any additional setup after loading the view, typically from a nib.
       let layout  = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView!.backgroundColor = UIColor.white
        collectionView?.collectionViewLayout = layout
        


        let headerNib = UINib.init(nibName: HeaderCell.reuseIdentifierString, bundle: nil)
        collectionView?.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifierString)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
//        let name: String = (filtersData?.filters[indexPath.item].key)!
//
//            let size: CGSize = name.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0)])
//
//            let sizeNew: CGSize = CGSize.init(width:((size.width  > collectionView.frame.size.width + 50) ? collectionView.frame.size.width + 50 : size.width), height: 50)
        
        let label = UILabel(frame: CGRect.zero)
        label.text = (filtersData?.filters[indexPath.item].key)!
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 45)
       

           
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersData?.filters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifierString, for: indexPath) as! TagCell

      
        cell.titleLabel?.text = filtersData?.filters[indexPath.item].key
        cell.titleLabel?.numberOfLines = 0
       
        var findit = (filtersData?.filters[indexPath.item].key)!
        if let gotit = gotSelectedFilters?[findit] as? String{
            print("We have reached ")
            cell.titleLabel?.text = gotit
            cell.outerVu.backgroundColor = UIColor().colorForHax("#E12E2E")
            cell.titleLabel?.textColor = UIColor.white
            cell.layer.borderWidth = 0
            cell.contentView.layer.cornerRadius = 0
        }else{
            cell.layer.borderColor = UIColor(named: "appRed")?.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.backgroundColor = UIColor.white
            cell.outerVu.backgroundColor = UIColor.white
            cell.titleLabel?.textColor = UIColor.black
        }
        if filtersData?.filters[indexPath.item].selected == true{
            cell.outerVu.backgroundColor = UIColor().colorForHax("#E12E2E")
            cell.titleLabel?.textColor = UIColor.white
            cell.layer.borderWidth = 0
            cell.contentView.layer.cornerRadius = 0
        }
        
        
        if selectedFilterCell.indices.contains(indexPath.item) != nil{
            if selectedFilterCell.indices.contains(indexPath.item) == true{
                cell.outerVu.backgroundColor = UIColor().colorForHax("#E12E2E")
                cell.titleLabel?.textColor = UIColor.white
                cell.layer.borderWidth = 0
                cell.contentView.layer.cornerRadius = 0
            }
        }
        
        cell.button.tag = indexPath.item
        cell.button.addTarget(self, action: #selector(collectionVuBtnTapped), for: .touchUpInside)
        

        //Cell Corner Radius
       
//        cell.outerVu.borderColor = UIColor(named: "appRed")
//        cell.outerVu.borderWidth = 2
//        cell.layer.cornerRadius = cell.frame.size.height / 2

        return cell
    }
    
    @objc func collectionVuBtnTapped(sender: UIButton!) {
    print("tapped")
        let cars = (filtersData?.filters[sender.tag].value)!
        var list = [KTItem]()
        for item in cars{
            let item1 = KTItem(id:nil, title:item, image:nil)
            list.append(item1)
            
        }
        let name = (filtersData?.filters[sender.tag].key)!
        showPopupOn(sender, list: list) { [self] (item) in
                print(item.title ?? "")
           
//            for _ in 0..<myNewDictArray.count{
//                if let doit = myNewDictArray[name]{
                   print("we have reached again")
                    myNewDictArray[name] = item.title ?? ""
                    print(myNewDictArray)
//                    let newElement = ["This":"you nailed"]
//                    myNewDictArray.append(newElement)
//                    print(myNewDictArray)
                    let indexPath = IndexPath(item: sender.tag, section: 0)
                    filtersData?.filters[sender.tag].selected = true
                    collectionView.reloadItems(at: [indexPath])
                }
                
//            }
//        }
        
        print(myNewDictArray)
        
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        min = Int(minValue)
        max = Int(maxValue)
        ageLbl.text = "\(min) - \(max)"
    }
    @IBAction func distanceBtns(_ sender: Any) {
        let tag = (sender as AnyObject).tag!
        distanceLbls.forEach({$0.textColor = UIColor(named: "grayText")})
        distanceLbls[tag].textColor = UIColor(named: "appRed")
    }
    @IBAction func distanceSlider(_ sender: UISlider) {
        selectedDistanceLbl.text = "\(Int(sender.value))"
    }
    
    @IBAction func heightBtnPressed(_ sender: Any) {
        let tag = (sender as AnyObject).tag!
        heightLbls.forEach({$0.textColor = UIColor(named: "grayText")})
        heightLbls[tag].textColor = UIColor(named: "appRed")
        if tag == 0
        {
            let vc = HeightPickerVC(nibName: "HeightPickerVC", bundle: nil)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else{
            userSelectedHeight = ""
        }
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyFilterBtnPressed(_ sender: Any)
    {
//        if DEFAULTS.string(forKey: "isPaid") == "0" {
//        }else{
        
        let minimumAge = Int(ageSlider.selectedMinValue)
        let maximumAge = Int(ageSlider.selectedMaxValue)
        
            let url = BASE_URL + "update/filters"
        let params = ["from_age":"\(minimumAge)", "to_age":"\(maximumAge)", "distance":"\(selectedDistanceLbl.text!)", "height":userSelectedHeight]
        myNewDictArray.merge(dict: params)
        print(myNewDictArray)
    
            postWebCall(url: url, params: myNewDictArray, webCallName: "Filters") { [unowned self](response, error) in
                if !error{
                    let success = "\(response["success"])"
                    if success == "true"{
                        oneStepBackPopUp(msg: "\(response["message"])", sender: self)
                    }
                }
                else{
                    self.alert(message: API_ERROR)
                }
            }
//        }
        
        
        
    }
    func getAvailbaleFilters(){
        let url = BASE_URL + "available-filters"
       let finalURL = URL(string:url)!
        
        
        getFiltersData(url: finalURL, onSuccess: { [self] (status, msg, res) in
              
//              let parseRes = ApiManager.responseParsingOrderHistory(result: res)
            
//            self.OrdersData = parseRes
            
            let jsonString = jsonToString(jsonTOConvert: res)
             let jsonData = jsonString.data(using: .utf8)
            
            let blogPosts: AvailableFilters = try! JSONDecoder().decode(AvailableFilters.self, from: jsonData!)
          print(blogPosts)
            filtersData = blogPosts
            collectionView.reloadData()
            
            
         }) { (status, msg, res) in
             
           
                
                 print("DO NOT RESET PRESCRIPTION COMMAND FROM PRESCRIPTION VC")
               
            
             print(res)
         }
       
    }
    func getSelectedFilters(){
        let url = BASE_URL + "get/filters"
       let finalURL = URL(string:url)!
        
        
        getFiltersData(url: finalURL, onSuccess: { [self] (status, msg, res) in
              
//              let parseRes = ApiManager.responseParsingOrderHistory(result: res)
            
//            self.OrdersData = parseRes
          
            let jsonString = jsonToString(jsonTOConvert: res)
             let jsonData = jsonString.data(using: .utf8)
            
            
            let json1 = try! JSONSerialization.jsonObject(with: jsonData!) as! [String:Any]
            let things = json1["filters"] as? [String:Any]
            
            gotSelectedFilters = things
            let blogPosts: FetchSelectedFilters = try! JSONDecoder().decode(FetchSelectedFilters.self, from: jsonData!)
          print(blogPosts)
            
            selectedFilters = blogPosts
            myNewDictArray["drink"] = selectedFilters?.filters?.drink ?? ""
            myNewDictArray["smoke"] = selectedFilters?.filters?.smoke
            myNewDictArray["gender_identity"] = selectedFilters?.filters?.gender_identity
            myNewDictArray["sexual_identity"] = selectedFilters?.filters?.sexual_identity
            myNewDictArray["pronouns"] = selectedFilters?.filters?.pronouns
            myNewDictArray["relationship_status"] = selectedFilters?.filters?.relationship_status
            myNewDictArray["looking_for"] = selectedFilters?.filters?.looking_for
            myNewDictArray["diet_like"] = selectedFilters?.filters?.diet_like
            myNewDictArray["cannabis"] = selectedFilters?.filters?.cannabis
            myNewDictArray["political_views"] = selectedFilters?.filters?.political_views
            myNewDictArray["religion"] = selectedFilters?.filters?.religion
            myNewDictArray["sign"] = selectedFilters?.filters?.sign
            myNewDictArray["pets"] = selectedFilters?.filters?.pets
            myNewDictArray["kids"] = selectedFilters?.filters?.kids
            if selectedFilters?.filters?.from_age != nil{
                guard let n = NumberFormatter().number(from: (selectedFilters?.filters?.from_age)!) else { return }
                
                ageSlider.selectedMinValue = CGFloat(truncating: n)
                ageSlider.setNeedsLayout()
                selectedMin = ageSlider.selectedMinValue
            }else{
                ageSlider.selectedMinValue = 18.0
            }
            if selectedFilters?.filters?.to_age != nil{
                guard let n = NumberFormatter().number(from: (selectedFilters?.filters?.to_age)!) else { return }
                ageSlider.selectedMaxValue = CGFloat(truncating: n)
                selectedMax = ageSlider.selectedMaxValue
            }else{
                ageSlider.selectedMaxValue = 60.0
            }
            min = Int(ageSlider.selectedMinValue)
            max = Int(ageSlider.selectedMaxValue)
            ageLbl.text = "\(min) - \(max)"
            if selectedFilters?.filters?.distance != nil{
                selectedDistanceLbl.text = selectedFilters?.filters?.distance!
                let distanceFloat = Float((selectedFilters?.filters?.distance)!)
                distanceSlider.setValue(distanceFloat!, animated: false)
               
            }
            if selectedFilters?.filters?.height != nil{
                selectedHeight.text = selectedFilters?.filters?.height
            }
           
            
            getAvailbaleFilters()
           
            
         }) { (status, msg, res) in
             
           
                
                 print("DO NOT RESET PRESCRIPTION COMMAND FROM PRESCRIPTION VC")
               
            
             print(res)
         }
       
    }
    func jsonToString(jsonTOConvert: AnyObject) -> String{
        do {
            let data =  try JSONSerialization.data(withJSONObject: jsonTOConvert, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let convertedString = String(data: data, encoding: String.Encoding.utf8) {
                return convertedString
            }
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
    
    
    @IBAction func clearFiltersBtnTpd(_ sender: Any) {
        let minimumAge = 18
        let maximumAge = 60
        
            let url = BASE_URL + "update/filters"
        let params = ["from_age":"\(minimumAge)", "to_age":"\(maximumAge)", "distance":"", "height":""]
        myNewDictArrayReplica.merge(dict: params)
        print(myNewDictArray)
    
            postWebCall(url: url, params: myNewDictArrayReplica, webCallName: "Filters") { [unowned self](response, error) in
                if !error{
                    let success = "\(response["success"])"
                    if success == "true"{
                        oneStepBackPopUp(msg: "\(response["message"])", sender: self)
                    }
                }
                else{
                    self.alert(message: API_ERROR)
                }
            }
    }
    
    
    
    
}

extension FilterVC : HeightProtocol{
    func heightPicker(feet: String, inch: String) {
        selectedHeight.text = "\(feet) \(inch)"
        userSelectedHeight = selectedHeight.text!
    }
}
extension FilterVC : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension UIColor {
    
    func colorForHax(_ rgba:String)->UIColor{
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex     = rgba.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                    break
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                    break
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                    break
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                    break
                    
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                    break
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
}





