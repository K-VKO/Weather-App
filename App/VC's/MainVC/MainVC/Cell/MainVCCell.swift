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
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    func setup(weather: Weather) {
        ImageLoaderService.shared.loadImage(name: weather.weather[0].icon) { grabbedImage in
            if let grabbedImage = grabbedImage {
                self.weatherImage.image = grabbedImage
            }
        }
        weatherDescription.text = weather.weather[0].description.capitalizeFirstLetter()
        weatherNumber.text = "\(Int(weather.weatherNumbers.temp)) °C"
    }
    
}
