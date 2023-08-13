//
//  Models.swift
//  Universiities
//
//  Created by Bekpayev Dias on 12.08.2023.
//

import Foundation

struct CountryData: Codable {
    let status: String
    let statusCode: Int?
    let version, access: String
    let data: [String: Country]
}

struct Country: Codable {
    let name: String
    let region: Region
    
    enum CodingKeys: String, CodingKey {
        case name = "country"
        case region
    }
}

enum Region: String, Codable {
    case africa = "Africa"
    case antarctic = "Antarctic"
    case asia = "Asia"
    case centralAmerica = "Central America"
}

struct UniversityData: Codable {
    let country: Country
    let domains: [String]
    let alphaTwoCode: AlphaTwoCode
    let stateProvince: String?
    let webPages: [String]
    let name: String
}

enum AlphaTwoCode: String, Codable {
    case us = "US"
}
