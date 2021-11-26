//
//  FontPicker.swift
//  TheICERegister
//
//  Created by abbas on 5/16/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class FontPicker:NSObject /*, UIPickerViewDelegate, UIPickerViewDataSource */ {
    
    var familyNames:[String:([String], [String])] = [:]
    var keys:[String] = []
    
    //var completion:((_ fontFamily:String)->Void)!
    var selectedKey:String = ""
    override init() {
        super.init()
        loadFonts()
        keys = Array(familyNames.keys).sorted()
        //let appFont = familyNames[Constants.appFont]
        //selectedKey = keys[62]
        //configurePickerFiew(view: view)
        //pickerView.reloadAllComponents()
    }
    /*
    func pickFamily(completion:@escaping ((_ fontFamily:String)->Void)) {
        let alert = UIAlertController(title: "Select Font?", message: nil, preferredStyle: .actionSheet)
        
         let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: /*frameSizes.index(of: 216) ??*/ 62)
        alert.addPickerView(values: [keys], initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            ///if index.column == 0 {
                //print("Hello......\n")
            self.selectedKey = self.keys[index.row]
            //}
        }
        
        alert.addAction(title: "Done", style: .cancel) { (action) in
            completion(self.selectedKey)
            //print("selected: \(self.selectedKey)")
        }
        
        alert.show()
    }
    
    func pickFont(fimaly:String, completion:@escaping ((_ fontName:String)->Void)) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Font Weight?", message: nil )
        let fontType = familyNames[fimaly]!.1
        var selectedFont = fontType.count > 0 ? familyNames[fimaly]!.0[0]:""
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        alert.addPickerView(values: [fontType], initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            selectedFont = self.familyNames[fimaly]!.0[index.row]
        }
        
        alert.addAction(title: "Done", style: .cancel) { (action) in
            completion(selectedFont)
        }
        
        alert.show()
    }
    
    func pickSize(completion:@escaping ((_ size:Int)->Void)) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Font Size?", message: nil )
        let fontSizes = (6...32).map { return "\(Int($0))"}
        var selectedSize = "14"
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 8)
        alert.addPickerView(values: [fontSizes], initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            selectedSize = fontSizes[index.row]
        }
        
        alert.addAction(title: "Done", style: .cancel) { (action) in
            completion((selectedSize as NSString).integerValue)
        }
        
        alert.show()
    }
    */
    fileprivate func loadFonts() {
        UIFont.familyNames.forEach({ familyName in
            familyNames[familyName] = ([],[])
        })
        
        for (selectedFimaly, _)in familyNames {
            let fontNm = UIFont.fontNames(forFamilyName: selectedFimaly)
            let fontNames = fontNm.map({ (fname) -> String in
                let name1 = selectedFimaly.replacingOccurrences(of: " ", with: "")
                let name = fname.replacingOccurrences(of: name1, with: "")
                return name == "" ? "-Regular":name
            })
            familyNames[selectedFimaly] = (fontNm,fontNames)
        }
    }
    
}
