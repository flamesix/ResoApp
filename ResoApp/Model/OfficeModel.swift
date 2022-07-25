//
//  OfficeModel.swift
//  ResoApp
//
//  Created by Юрий Гриневич on 12.07.2022.
//

import Foundation
import CoreLocation

struct OfficeModel: Decodable {
    
    let id: Int
    let officeName: String
    let fullAddress: String
    let shortAddress: String
    let openHours: String?
    let phones: String
    let longitude: Double
    let latitude: Double
    let officeTimeZone: String
    let officeWorkingHours: [OfficeWorkingHours]?
    let contactPhones: [ContactPhones]
    var distance: CLLocation {
        return CLLocation(latitude: latitude , longitude: longitude)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case officeName = "SSHORTNAME"
        case fullAddress = "SADDRESS"
        case shortAddress = "SSHORTADDRESS"
        case openHours = "SGRAF"
        case phones = "SPHONE"
        case longitude = "NLONG"
        case latitude = "NLAT"
        case officeTimeZone = "NTIMEZONE"
        case officeWorkingHours = "GRAF"
        case contactPhones = "CPHONE"
    }
}

struct OfficeWorkingHours: Decodable {
    let dayCount: Int
    let startTime: String
    let endTime: String
    
    enum CodingKeys: String, CodingKey {
        case dayCount = "NDAY"
        case startTime = "SBEGIN"
        case endTime = "SEND"
    }
}


struct ContactPhones: Decodable {
    let contactPhone: String
    
    enum CodingKeys: String, CodingKey {
        case contactPhone = "SPHONE"
    }
}
