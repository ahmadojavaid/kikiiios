//
//  ErrorMsgs.swift
//  Coins
//
//  Created by Shahbaz on 21/05/2020.
//  Copyright © 2020 Shahbaz. All rights reserved.
//

import Foundation
enum ErrorMessage : String, Error
{
    case invalidResponse    = "Invalid Response, Please try later"
    case serverError        = "Error accoured at server side, please try again"
    case noInterNet         = "Internet is not connected, please connent and try again"
    case inValidUserName    = "This is invalid User name"
    case enterName          = "Please Enter Name"
    case noPhone            = "Please Enter a valid phone number"
    case emptyID            = "membership ID should not be empty"
    case emptyPassword1     = "Please Enter Password"
    case emptyPassword2     = "Please Enter Confirm Password"
    case passwordLength     = "Password must at least 4 characters long"
    case passwordNotMatched = "Password does not match"
    case enterMedName       = "Enter medicine name"
    case selectDay          = "Select day"
    case duration           = "Please select duration"
    case enterTime          = "Please enter time"
    case enterQuantity      = "Please Enter Quantity"
    case enterBodyWeight    = "Please enter body weight"
    case enterAge           = "Please enter your age"
    case enterGender        = "Please select gender"
    case enterFeet          = "Please enter your height feet"
    case enterInch          = "Please enter your height inches"
    case enterEmail         = "Please enter your email"
    case invalidEmail       = "Please enter a valid email"
    case birthday           = "Please enter birth day"
}



extension String{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

