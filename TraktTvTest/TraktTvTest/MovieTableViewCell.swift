//
//  MovieTableViewCell.swift
//  TraktTvTest
//
//  Created by Guglielmo on 15/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    //GUI: image loading task
    var imageLoaderTask: NSURLSessionDataTask? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showMovie(movie: Movie?)
    {
        backgroundImageView.image = nil
        if let title = movie?.title  {mainTitleLabel.text = "\(title)"}
        if let year = movie?.year?.stringValue {mainTitleLabel.text?.appendContentsOf(" - \(year)")}        
        
        if let banner = movie?.banner{
            imageLoaderTask = ImageLoader.loadImage(banner, completationBlock: { (image: UIImage?, error: NSError?) -> Void in
                //GUI: on ui thread
                if error == nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.backgroundImageView.image = image
                    })
                }
            })
        }
        else
        {
            NSLog("no image")
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        imageLoaderTask?.cancel()
        imageLoaderTask = nil
    }

}
