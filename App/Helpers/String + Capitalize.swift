//
//  String + Capitalize.swift
//  App
//
//  Created by Константин Вороненко on 11.03.22.
//

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizeFirstLetter()
    }
}
