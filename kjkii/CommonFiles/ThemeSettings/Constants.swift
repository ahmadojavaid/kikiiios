//
//  Constants.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import UIKit
let appDelegate  = UIApplication.shared.delegate as! AppDelegate
struct Constants {
    
    static let baseURL = "https://dev2.polse.jobesk.com"
    static let appFont = "Lato"
        
}

struct AppData {
    static let GENDER_IDENTITY = ["Agender", "Androgyne", "Bigender", "Gender Fluid", "Gender Non-Conforming", "Genderqueer", "Neutrosis", "Non-Binary", "Pangender", "Polygender", "Prefer not to say", "Prefer to self describe", "Questioning", "Trans Feminine", "Trans Man", "Trans Masculine", "Trans Womxn", "Tow-Spirit", "Womxn"]
    
    static let Sexual_identity = [ "Androsexual", "Asexual", "Bicurious", "Bisexual", "Demisexual", "Flexisexual", "Fluid", "Gay", "Heteroflexible", "Homoflexible", "Lesbian", "Pansexual", "Polysexual", "Prefer not to say", "Prefer to self describe", "Queer", "Questioning", "Skoliosexual", "Straight" ]
    
    static let Your_Pronouns = ["She / Her", "He / Him", "They / Them", "Ze / hir / hirs", "Prefer to self describe", "Prefer not to say"]
    
    static let RELATIONSHIP_STATUS = ["Single", "Dating", "Coupled", "Married", "Divorced", "Prefer not to say", ]
    
    static let LOOKING_FOR = ["Monogamous Relationship", "Polyamorous Relationship", "Something Casual", "New Friends", "Not Sure Yet", "Prefer not to say"]
    
    static let YOU_DRINK = [ "No", "Occasionally", "Socially", "Prefer not to say"
    ]
    
    static let SMOKE = ["No", "Occasionally", "Regularly", "Socially", "Prefer not to say"]
    
    static let CANNABIS = SMOKE
    static let POLITICAL_VIEWS = ["Liberal", "Conservative", "Moderate", "Other", "Not Political", "Prefer not to say"]
    static let RELIGION = ["Agnostic", "Atheist", "Buddhist", "Christian", "Jewish", "Hindu", "Mormon", "Muslim", "Spirtual", "Rastafarian ", "Pagan", "Prefer not to say", "Others"]
    static let DISLIKES = ["Vegetarian", "Vegan", "Pescatarian", "Gluten-free", "I eat everything", "Kosher", "other", "Prefer not to say"]
    static let SIGN = ["Capricorn", "Aquarius", "Pisces", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Aries", "Scorpio", "Sagittarius", "Prefer not to say"]
    static let PETS = ["Dogs", "Cats", "Hsmster", "Reptile", "Bird", "Rabbit"]
    static let KIDS = ["Have Kids", "Want Someday", "Don't Want", "No Sure Yet", "Prefer not to Say"]
    
    static var curOptions = ["single", "height", "Looking for?", "Do you drink?", "Do you smoke?", "Do you use Cannabis?", "Political Views?", "Your religion", "Dite like?", "Your sign?", "Any Pets?", "Want Kids"]
    
    static let feet = ["2'", "3'", "4'", "5'", "6'", "7'", "8'"]
    static let inches = ["0\"","1\"","2\"","3\"","4\"","5\"","6\"","7\"","8\"","9\"","10\"", "11\"","12\"",]
}


enum EditProfileCategories{
    static let GENDER_IDENTITY      = "gender_identity"
    static let SEXUAL_IDENTITY      = "sexual_identity"
    static let PRONOUNS             = "pronouns"
    static let RELATIONSHIP_STATUS  = "relationship_status"
    static let HEIGHT               = "height"
    static let DISTANCE_IN          = "distance_in"
    static let LOOKING_FOR          = "looking_for"
    static let DRINK                = "drink"
    static let DIET_LIKE            = "diet_like"
    static let SMOKE                = "smoke"
    static let CANNABIS             = "cannabis"
    static let POLITICAL_VIEWS      = "political_views"
    static let RELIGION             = "religion"
    static let SIGN                 = "sign"
    static let PETS                 = "pets"
    static let KIDS                 = "kids"
}
enum EditProfileLabels{
    static let GENDER_IDENTITY      = "WHAT'S YOUR GENDER IDENTITY?"
    static let SEXUAL_IDENTITY      = "WHAT'S YOUR SEXUAL IDENTITY?"
    static let PRONOUNS             = "WHAT'S YOUR PRONOUNS?"
    static let RELATIONSHIP_STATUS  = "WHAT'S YOUR RELATIONSHIP STATUS?"
    static let HEIGHT               = "HEIGHT"
    static let DISTANCE_IN          = "distance_in"
    static let LOOKING_FOR          = "WHAT ARE YOU LOOKING FOR?"
    static let DRINK                = "DO YOU DRINK?"
    static let DIET_LIKE            = "WHAT'S YOUR DIET LIKE?"
    static let SMOKE                = "DO YOU SMOKE CIGARETTES?"
    static let CANNABIS             = "DO YOU USE CANNABIS?"
    static let POLITICAL_VIEWS      = "WHAT ARE YOUR POLITICAL VIEWS?"
    static let RELIGION             = "WHAT'S YOUR RELIGION?"
    static let SIGN                 = "WHAT'S YOUR SIGN?"
    static let PETS                 = "DO YOU HAVE PETS?"
    static let KIDS                 = "DO YOU HAVE OR WANT KIDS?"
    
}

enum EditProfileType{
    case gender, sex, pro, bio, menu
}
