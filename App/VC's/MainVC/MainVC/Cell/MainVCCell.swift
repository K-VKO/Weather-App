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
    @IBOutlet var viewsToRound: [UIView]!
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherNumber: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleText: UILabel!
    
    
    func setupTodayWeather(weather: Weather) {
        ImageLoaderService.shared.loadImage(name: weather.weather[0].icon) { grabbedImage in
            if let grabbedImage = grabbedImage {
                self.weatherImage.image = grabbedImage
            }
        }
        weatherDescription.text = weather.weather[0].description.capitalizeFirstLetter()
        weatherNumber.text = "\(Int(weather.weatherNumbers.temp)) °C"
    }
    
    func setupArticle(article: Article) {
        self.articleText.text = article.title
        ImageLoaderService.shared.loadImage(url: article.urlToImage) {[weak self] grabbedImage in
            if let grabbedImage = grabbedImage {
                self?.articleImage.image = grabbedImage
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        viewsToRound.forEach { view in
            view.layer.cornerRadius = 15.0
            view.clipsToBounds = true
        }
    }
}
