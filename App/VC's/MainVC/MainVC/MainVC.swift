//
//  MainVC.swift
//  App
//
//  Created by Константин Вороненко on 6.03.22.
//

import UIKit
import RxSwift
import RxCocoa

final class MainVC: UIViewController {
    private let viewModel: MainVCViewModelProtocol = MainVCViewModel()
    private let disposeBag =  DisposeBag()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self

            tableView.registerCell(type: MainVCCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadArticle()
        viewModel.getUserLocation()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: MainVCCell.self) as! MainVCCell
        
        viewModel.weather.subscribe { event in
            if let weather = event.element {
                cell.setupTodayWeather(weather: weather)
            }
        }.disposed(by: disposeBag)
        
        viewModel.article.subscribe { event in
            if let article = event.element {
                cell.setupArticle(article: article)
            }
        }.disposed(by: disposeBag)
        
        return cell
    }
}
