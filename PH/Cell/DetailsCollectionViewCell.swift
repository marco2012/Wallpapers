//
//  DetailsCollectionViewCell.swift
//  PH
//
//  Created by Marco on 18/08/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailsCollectionImageView: UIImageView!
    
    override func awakeFromNib() {
        detailsCollectionImageView.layer.borderColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        detailsCollectionImageView.layer.borderWidth = 0.5
        detailsCollectionImageView.layer.cornerRadius = 6
    }
}
