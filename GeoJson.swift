//
//  GeoJson.swift
//  ios_final
//
//  Created by ios프로젝트 on 6/17/24.
//

import Foundation
import MapKit

struct GeoJSON: Codable {
    let type: String
    let features: [Feature]
}

struct Feature: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry
}

struct Properties: Codable {
    let code: String
    let name: String
    let name_eng: String
    let base_year: String
}

struct Geometry: Codable {
    let type: String
    let coordinates: [[[Double]]]
}
