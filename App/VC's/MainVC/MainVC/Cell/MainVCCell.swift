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
    var viewModel: MainVCCellViewModelProtocol = MainVCCellViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet var viewsToRound: [UIView]!
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherNumber: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleText: UILabel!
    
    func setupTodayWeather(weather: Weather) {
        weatherImage.image = UIImage(named: weather.weather[0].icon)
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
    
    private func bind() {
        viewModel.weather.subscribe {[weak self] event in
            if let weather = event.element {
                self?.setupTodayWeather(weather: weather)
            }
        }.disposed(by: disposeBag)
        
        viewModel.article.subscribe {[weak self] event in
            if let article = event.element {
                self?.setupArticle(article: article)
            }
        }.disposed(by: disposeBag)
        
        viewModel.cityNameToDisplay.subscribe {[weak self] event in
            if let cityName = event.element {
                self?.cityName.text = cityName
            }
        }.disposed(by: disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
        viewModel.loadWeatherFromDB()
        viewModel.getUserLocation()
        viewModel.loadArticle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewsToRound.forEach { view in
            view.layer.cornerRadius = 15.0
            view.clipsToBounds = true
        }
    }
}
