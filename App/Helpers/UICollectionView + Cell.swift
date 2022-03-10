//
//  UICollectionView + Cell.swift
//  App
//
//  Created by Константин Вороненко on 10.03.22.
//

import UIKit

extension UICollectionView {
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: identifier ?? cellId)
    }
    
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
            return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
    
}

public extension UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
