//
//  SigninVC.swift
//  kjkii
//
//  Created by Shahbaz on 08/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseAuth
import CountryPickerView
class GetPhoneNumber: UIViewController {
    
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryName: APLabel!
    @IBOutlet weak var phone_number_text: UITextField!
    @IBOutlet weak var code_text        : UITextField!
    var verificationID  = String()
    var country_code    = String()
    let code_picker     = UIPickerView()
    var all_countries   = IsoCountries.allCountries
    var selected_index  = Int()
    var num             = String()
    var type            = String()
    
    let countryPickerView = CountryPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setCountryCode()
        code_text.delegate = self
        
    }
    
    func setCountryCode()
    {

        
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        code_text.leftView                  = cpv
        code_text.leftViewMode              = .always
        code_text.rightViewMode             = .never
//        code_text.isUserInteractionEnabled  = false
        //code_text.inputView     = code_picker
        let locale              = Locale.current
        let country             = locale.regionCode!
        for i  in 0..<all_countries.count
        {
            if all_countries[i].alpha2 == country
            {
                selected_index = i
            }
        }
        code_text.text = all_countries[selected_index].name + " (" + all_countries[selected_index].calling + ")"
        
        setCountryFlagData(code: all_countries[selected_index].calling)
        
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        let code    = country_code
        let number  = phone_number_text.text!
        if number.first == "0"
        {
            num = code + "\(number.dropFirst())"
        }
        else
        {
            num = code + "\(number)"
        }
        sendCode(phoneNumber: num)
    }
    
    func sendCode(phoneNumber:String)
    {
        KRProgressHUD.showMessage("Please Wait.. ")
        sendCodeAfterVerificiation(trimmed: phoneNumber) { [weak self] (done) in
            guard let self = self else {return }
            if done{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterOTPVC") as! EnterOTPVC
                vc.verificationID = self.verificationID
                vc.phone = phoneNumber
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    func sendCodeAfterVerificiation(trimmed: String, completion : @escaping (_ done: Bool)-> Void)
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(trimmed, uiDelegate: self) { [unowned self] (verificationID, error) in
            if error != nil
            {
                print("eror: \(error?.localizedDescription)")
                KRProgressHUD.dismiss()
                self.alert(message: "Could not send code, please try later")
                completion(false)
            }
            else
            {
                
                KRProgressHUD.dismiss()
                self.verificationID = verificationID!
                completion(true)
            }
        }
    }
    
    @IBAction func countryBtnPressed(_ sender: Any)
    {
        countryPickerView.showCountriesList(from: self)
        countryPickerView.delegate = self
    }
    
}




extension GetPhoneNumber: UIPickerViewDelegate, UIPickerViewDataSource, AuthUIDelegate, UITextFieldDelegate, CountryPickerViewDelegate
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        dump(country)
        setCountryFlagData(code: country.phoneCode)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return all_countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  all_countries[row].name + all_countries[row].calling
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        code_text.text = all_countries[row].name + " (" + all_countries[row].calling + ")"
        country_code = all_countries[row].calling
    }
    

    
    
    func setCountryFlagData(code: String){
        let countryPickerView   = CountryPickerView()
        if let country = countryPickerView.getCountryByPhoneCode(code){
            countryFlag.image   = country.flag
            countryName.text    = country.name
            country_code        = country.phoneCode
            codeLbl.text        = country.phoneCode
        }
        else{
            alert(message: "Country not found")
            codeLbl.text        = "0"
        }
        
        
    }
}
////////////////////////////////////////////////////////
//*****      Picker Delegates end here  ***************
////////////////////////////////////////////////////////
