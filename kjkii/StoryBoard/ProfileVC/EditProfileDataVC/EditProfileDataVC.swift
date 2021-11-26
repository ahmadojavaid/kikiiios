//
//  EditProfileDataVC.swift
//  kjkii
//
//  Created by Shahbaz on 06/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class EditProfileDataVC: UIViewController {
    
    @IBOutlet weak var heightView   : UIView!
    @IBOutlet weak var heightPicker : UIPickerView!
    @IBOutlet weak var vcTitle      : APLabel!
    @IBOutlet weak var clcView      : UICollectionView!
    var isMenu          = false
    var items           = [McqOptions]()
    var optionsToGet    = String()
    var delegate        : EditValue?
    var selectedValues  = String()
    var inch = String()
    var foot = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.popView(sender: self)
        clcView.register(UINib(nibName: "MCQsCell", bundle: nil), forCellWithReuseIdentifier: "MCQsCell")
        clcView.register(UINib(nibName: "VerticalCell", bundle: nil), forCellWithReuseIdentifier: "VerticalCell")
        clcView.delegate    = self
        clcView.dataSource  = self
        heightView.isHidden = true
        initialSetup()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        delegate?.selectedValue(selectedValue: selectedValues)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateProfileBtnPressed(_ sender: Any) {
    }
    
    
    
    
    
    
}

extension EditProfileDataVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if isMenu{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerticalCell", for: indexPath) as! VerticalCell
            cell.configCell(item: items[indexPath.row])
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCQsCell", for: indexPath) as! MCQsCell
            cell.setData(item: items[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<items.count{
            items[i].isSelected = false
        }
        items[indexPath.row].isSelected = true
        selectedValues = items[indexPath.row].itemName
        clcView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isMenu{
            return CGSize(width: collectionView.frame.size.width, height: 50)
        }
        else{
            let label = UILabel(frame: CGRect.zero)
            label.text = items[indexPath.row].itemName
            label.sizeToFit()
            return CGSize(width: label.frame.width + 28, height: 30)
        }
    }
}

extension EditProfileDataVC{
    func getData(){
        let request = EditProfileAttr(item: optionsToGet)
        request.getItems { [unowned self](result) in
            switch result{
            case .success(let data):
                if let values = data.value{
                    for value in values{
                        self.items.append(McqOptions(itemName: value, isSelected: false))
                    }
                    self.clcView.reloadData()
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
        
    }
}





protocol EditValue {
    func selectedValue(selectedValue: String)
}


extension EditProfileDataVC{
    func initialSetup(){
        if optionsToGet ==  EditProfileCategories.GENDER_IDENTITY {
            isMenu = true
            vcTitle.text =  EditProfileLabels.GENDER_IDENTITY
        } else if optionsToGet ==  EditProfileCategories.SEXUAL_IDENTITY {
            isMenu = true
            vcTitle.text =  EditProfileLabels.SEXUAL_IDENTITY
        } else if optionsToGet == EditProfileCategories.PRONOUNS {
            isMenu = true
            vcTitle.text =  EditProfileLabels.PRONOUNS
        } else if optionsToGet == EditProfileCategories.RELATIONSHIP_STATUS {
            isMenu = false
            vcTitle.text =  EditProfileLabels.RELATIONSHIP_STATUS
        } else if optionsToGet == EditProfileCategories.HEIGHT {
            isMenu = false
            vcTitle.text =  EditProfileLabels.HEIGHT
        } else if optionsToGet == EditProfileCategories.LOOKING_FOR {
            isMenu = false
            vcTitle.text =  EditProfileLabels.LOOKING_FOR
        } else if optionsToGet == EditProfileCategories.DRINK {
            isMenu = false
            vcTitle.text =  EditProfileLabels.DRINK
        } else if optionsToGet == EditProfileCategories.DIET_LIKE {
            isMenu = false
            vcTitle.text =  EditProfileLabels.DIET_LIKE
        } else if optionsToGet == EditProfileCategories.SMOKE {
            isMenu = false
            vcTitle.text =  EditProfileLabels.SMOKE
        } else if optionsToGet == EditProfileCategories.CANNABIS {
            isMenu = false
            vcTitle.text =  EditProfileLabels.CANNABIS
        } else if optionsToGet == EditProfileCategories.POLITICAL_VIEWS {
            isMenu = false
            vcTitle.text =  EditProfileLabels.POLITICAL_VIEWS
        } else if optionsToGet == EditProfileCategories.RELIGION {
            isMenu = false
            vcTitle.text =  EditProfileLabels.RELIGION
        } else if optionsToGet == EditProfileCategories.SIGN {
            isMenu = false
            vcTitle.text =  EditProfileLabels.SIGN
        } else if optionsToGet == EditProfileCategories.PETS {
            isMenu = false
            vcTitle.text =  EditProfileLabels.PETS
        } else if optionsToGet == EditProfileCategories.KIDS {
            isMenu = false
            vcTitle.text =  EditProfileLabels.KIDS
        }
        if optionsToGet == EditProfileCategories.HEIGHT {
            clcView.isHidden            = true
            heightView.isHidden         = false
            heightPicker.delegate       = self
            heightPicker.dataSource     = self
            foot                        = AppData.feet[0]
            inch                        = AppData.inches[0]
            selectedValues              = "\(foot) \(inch)"
        }
        else{
            getData()
        }
    }
}


extension EditProfileDataVC : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return AppData.feet.count
        }
        else{
            return AppData.inches.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return AppData.feet[row]
        }
        else{
            return AppData.inches[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            foot = AppData.feet[row]
        } else{
            inch = AppData.inches[row]
        }
        
        selectedValues = "\(foot) \(inch)"
        print(selectedValues)
        
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
}


