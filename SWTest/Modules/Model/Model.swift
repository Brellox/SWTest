//
//  Model.swift
//  SWTest
//
//  Created by Иван Суслов on 28.06.2021.
//

import Foundation

struct Valute: Codable
{
    var numCode: String
    var charCode: String
    var nominal: Int
    var name: String
    var value: Double
}
