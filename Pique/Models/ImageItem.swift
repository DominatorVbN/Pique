//
//  ImageItem.swift
//  Pique
//
//  Created by Amit Samant on 07/06/25.
//

import Foundation
import SwiftUI

struct ImageItem: Identifiable {
    let name: String
    let image: Image
    let id: String = UUID().uuidString
}

extension ImageItem {
    static let mcritchieFlower = ImageItem(name: "Flower at McRitchie", image: Image(.mcritchieflower))
    static let mcritchieRiver = ImageItem(name: "River at McRitchie", image: Image(.mcritchieriver))
    static let birdParadise = ImageItem(name: "Bird Paradise", image: Image(.birdparadise))
    static let capitagreen = ImageItem(name: "Capita Green", image: Image(.capitagreen))
    static let marinaBaySands = ImageItem(name: "Marina Bay Sands", image: Image(.marinabaysands))
    
    static let allCases: [ImageItem] = [
        .mcritchieFlower,
        .mcritchieRiver,
        .birdParadise,
        .capitagreen,
        .marinaBaySands
    ]
}
