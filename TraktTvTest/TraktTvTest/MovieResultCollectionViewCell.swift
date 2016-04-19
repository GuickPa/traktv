//
//  MovieResultCollectionViewCell.swift
//  TraktTvTest
//
//  Created by Guglielmo on 18/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//

import UIKit

class MovieResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    func showMovieResult(movie: Movie?)
    {
        backgroundImageView.image = nil
        if let title = movie?.title  {titleLabel.text = "\(title)"}
        if let year = movie?.year {titleLabel.text?.appendContentsOf(" - \(year)")}
        if let overview = movie?.overview {overviewLabel.text = "\(overview)"}
        
        if let poster = movie?.poster{
            ImageLoader.loadImage(poster, completationBlock: { (image: UIImage?, error: NSError?) -> Void in
                //GUI: on ui thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.backgroundImageView.image = image
                })
            })
        }
    }
}
