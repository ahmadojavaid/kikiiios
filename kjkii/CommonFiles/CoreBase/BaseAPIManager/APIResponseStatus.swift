//
//  APIResponseStatus.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import Foundation

struct APIResponseStatus {
    var isSuccess = false
    var code: Int = 0
    var message = ""
    
    init() {}
    init(isSuccess: Bool, code: Int, message: String) {
        self.isSuccess = isSuccess
        self.code = code
        self.message = message
    }
    init(error: NSError) {
        self.isSuccess = false
        self.code = error.code
        self.message = error.localizedDescription
    }
    
    static var success: APIResponseStatus {
        return APIResponseStatus(isSuccess: true, code: 200, message: ErrorMessages.noNetwork.localized)
    }
    static var noNetwork: APIResponseStatus {
        return APIResponseStatus(isSuccess: false, code: 503, message: ErrorMessages.noNetwork.localized)
    }
    static var unauthenticated: APIResponseStatus {
        return APIResponseStatus(isSuccess: false, code: 401, message: "Your authentication token seems to be invalid. To correct this please trying logging in again.")
    }
    static var unknown: APIResponseStatus {
        return APIResponseStatus(isSuccess: false, code: 404, message: ErrorMessages.unknown.localized)
    }
    static var invalidRequest: APIResponseStatus {
        return APIResponseStatus(isSuccess: false, code: 422, message: ErrorMessages.invalidRequest.localized)
    }
    static var invalidResponse: APIResponseStatus {
        return APIResponseStatus(isSuccess: false, code: 422, message: ErrorMessages.invalidResponse.localized)
    }
}
