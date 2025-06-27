//
//  DateHelpers.swift
//
//  Created by Meir Radnovich on 14/08/2022.
//

import Foundation

extension Date {
    var debugDescription: String {
        Constants.dateFormatter.string(from: self)
    }
}
