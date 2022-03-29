//
//  MainVCCell.swift
//  App
//
//  Created by Константин Вороненко on 6.03.22.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainVCCellDelegate {
    func showAlert()
}

final class MainVCCell: UITableViewCell {
    private var viewModel: MainVCCellViewModelProtocol = MainVCCellViewModel()
    let disposeBag = DisposeBag()
    
    var delegate: MainVCCellDelegate?
    
    @IBOutlet var viewsToRound: [UIView]!
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherNumber: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherUpdatedDate: UILabel!
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleText: UILabel!
    
    func setupTodayWeather(weather: Weather) {
        cityName.text = weather.cityName
        weatherImage.image = UIImage(named: weather.weather[0].icon)
        weatherDescription.text = weather.weather[0].description.capitalizeFirstLetter()
        weatherNumber.text = weather.weatherNumbers.temp?.addCelsius()
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
        
        viewModel.weatherUpdateDate.subscribe {[weak self] event in
            if let weatherUpdateDate = event.element {
                self?.weatherUpdatedDate.text = "Last updated: \(weatherUpdateDate)"
            }
        }.disposed(by: disposeBag)
        
        
        viewModel.isAccessDenied.subscribe {[weak self] event in
            if let accessDenied = event.element,
            accessDenied == true {
                self?.delegate?.showAlert()
            }
        }.disposed(by: disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
        
        //MARK: Trying to load weather from DB if it exists
        viewModel.loadWeatherFromDB()
        viewModel.getWeatherUpdateDate()
        
        //MARK: Updating weather from API
        viewModel.getUserLocationAndLoadWeather()
        
        //MARK: Loading article
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
