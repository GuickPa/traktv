//
//  ImageLoader.swift
//  TraktTvTest
//
//  Created by Guglielmo on 15/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//

import UIKit

class ImageLoader: NSObject {
    
    class func loadImage(url: String!, completationBlock: (UIImage?, NSError?) -> Void) -> NSURLSessionDataTask?
    {
        return RequestManager.sharedInstance().GET(url, params: nil, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let imageData = data{
                let loadedImage: UIImage? = UIImage(data: imageData)
                if var image = loadedImage {
                    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
                    image.drawAtPoint(CGPointZero)
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    completationBlock(image, nil)
                }
                else
                {
                    completationBlock(nil, error)
                }                
            }
        })
    }
}
