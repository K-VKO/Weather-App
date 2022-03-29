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
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.registerCell(type: MainVCCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: MainVCCell.self) as! MainVCCell
        cell.delegate = self
        return cell
    }
}

extension MainVC: MainVCCellDelegate {
    func showAlert() {
        let alertController = UIAlertController(title: "Attention!", message: "App needs permission to use your location", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }
}
