//
//  RequestManager.swift
//  TraktTvTest
//
//  Created by Guglielmo on 14/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let baseURL = "https://api-v2launch.trakt.tv/"
    let apiKey = "ad005b8c117cdeee58a1bdb7089ea31386cd489b21e14b19818c91511f12a086"
    
    static private var singleton: RequestManager? = nil
    
    class func sharedInstance() -> RequestManager!{
        if singleton == nil
        {
            singleton = RequestManager();
        }
        return singleton;
    }
    
    func buildMutableRequest(urlString: String!, params: NSDictionary?) -> NSMutableURLRequest?
    {
        //GUI: init mutable request
        let completeURL: String = baseURL + urlString;
        let url: NSURL? = NSURL(string: completeURL)
        let request: NSMutableURLRequest? = NSMutableURLRequest(URL: url!);
        request?.addValue(apiKey, forHTTPHeaderField: "trakt-api-key");
        request?.addValue("2", forHTTPHeaderField: "trakt-api-version");
        request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            if params != nil
            {
                let bodyData: NSData? = try NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted)
                request?.HTTPBody = bodyData
            }
        }
        catch{
        
        }
        
        return request;
    }
    
    
    func GET(urlString: String!, params: NSDictionary?, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)
    {
        //GUI: init mutable request
        let request: NSMutableURLRequest? = buildMutableRequest(urlString, params: params)
        //GUI: add header to request
        let dataTask: NSURLSessionDataTask? = defaultSession.dataTaskWithRequest(request!) {
            data, response, error in

            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }

            if let error = error {
                print(error.localizedDescription)
                completionHandler(nil, response, error)
            } else {
                completionHandler(data, response, nil)
            }
        
        }
        if dataTask != nil
        {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            dataTask!.resume()
        }
        else
        {
            completionHandler(nil, nil, nil)
        }
    }

}
