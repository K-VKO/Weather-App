//
//  MainVCCell.swift
//  App
//
//  Created by Константин Вороненко on 6.03.22.
//

import UIKit

final class MainVCCell: UITableViewCell {
    @IBOutlet var viewsToRound: [UIView]! {
        didSet {
            viewsToRound.forEach { $0.layer.cornerRadius = 15 }
        }
    }
}
