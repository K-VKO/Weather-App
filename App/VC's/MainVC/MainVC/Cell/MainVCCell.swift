//
//  MainVCCell.swift
//  App
//
//  Created by Константин Вороненко on 6.03.22.
//

import UIKit
import RxSwift
import RxCocoa

final class MainVCCell: UITableViewCell {
    @IBOutlet var viewsToRound: [UIView]! {
        didSet {
            viewsToRound.forEach { $0.layer.cornerRadius = 15 }
        }
    }
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherNumber: UILabel!
    
    
    func setup(weather: Weather) {
        weatherDescription.text = weather.weather[0].description.capitalizeFirstLetter()
        weatherNumber.text = "\(Int(weather.weatherNumbers.temp)) °C"
    }
    
}
