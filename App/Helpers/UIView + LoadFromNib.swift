//
//  UIView + LoadFromNib.swift
//  App
//
//  Created by Константин Вороненко on 10.03.22.
//

import UIKit


extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}
