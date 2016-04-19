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
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    //GUI: image loading task
    var imageLoaderTask: NSURLSessionDataTask? = nil
    
    func showMovieResult(movie: Movie?)
    {
        backgroundImageView.image = nil
        loadingView.startAnimating()
        if let title = movie?.title  {titleLabel.text = "\(title)"}
        if let year = movie?.year {titleLabel.text?.appendContentsOf(" - \(year)")}
        if let overview = movie?.overview {overviewLabel.text = "\(overview)"}
        
        if let poster = movie?.poster{
            imageLoaderTask = ImageLoader.loadImage(poster, completationBlock: { (image: UIImage?, error: NSError?) -> Void in
                //GUI: on ui thread
                if error == nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.backgroundImageView.image = image
                        self.loadingView.stopAnimating()
                    })
                }
            })
        }
        else
        {
            self.loadingView.stopAnimating()
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        imageLoaderTask?.cancel()
        imageLoaderTask = nil
    }
}
