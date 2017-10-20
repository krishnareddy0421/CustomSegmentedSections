//
//  ArticleCell.swift
//  CustomSegmentedSections
//
//  Created by vamsi krishna reddy kamjula on 10/19/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var articleTitleLbl: UILabel!
    
    func configureCell(_ articleDetails: Article) {
        thumbnailImgView.image = articleDetails.thumbnailImg
        articleTitleLbl.text = articleDetails.title
    }
}
