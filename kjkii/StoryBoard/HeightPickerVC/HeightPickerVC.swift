//
//  HeightPickerVC.swift
//  kjkii
//
//  Created by Shahbaz on 29/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class HeightPickerVC: UIViewController {
    var delegate : HeightProtocol?
    @IBOutlet weak var heightPicker: UIPickerView!
    
    let feet = ["4'", "5'", "6'", "7'", "8'"]
    var inches = [String]()
    var selectedFeet    = String()
    var selectedInches  = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInches()
        heightPicker.delegate   = self
        heightPicker.dataSource = self
        selectedFeet = feet.first!
        selectedInches = inches.first!
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func createInches(){
        for i in 0...10{
            inches.append("\(i)\"")
        }
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        delegate?.heightPicker(feet: selectedFeet, inch: selectedInches)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension HeightPickerVC : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return feet.count
        } else{
            return inches.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return feet[row]
        } else{
            return inches[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
             selectedFeet   = feet[row]
        } else{
            selectedInches  =  inches[row]
        }
    }
    
    
}


protocol HeightProtocol {
    func heightPicker(feet: String, inch: String)
}
