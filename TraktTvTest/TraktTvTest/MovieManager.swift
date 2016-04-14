//
//  MoviesManager.swift
//  TraktTvTest
//
//  Created by Guglielmo on 14/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//
//  GUI: manager singleton class - loads and stores movies

import UIKit

class MovieManager: NSObject {
    
    static var singleton: MovieManager? = nil
    //GUI: list of movies
    var movies: NSMutableArray! = NSMutableArray(capacity: 100)
    
    class func sharedInstance() -> MovieManager!{
        if singleton == nil{
            singleton = MovieManager();
        }
        
        return singleton;
    }
    
    //GUI: helper function to convert JSON array in list of movie entries
    private func buildListFromJSONObject(jsonObject: AnyObject!)
    {
        if jsonObject is NSArray{
            let list: NSArray! = jsonObject as! NSArray
            for infoItem in list
            {
                let item:NSDictionary! = infoItem as! NSDictionary
                let movie: Movie = Movie(info: item);
                movies.addObject(movie)
            }
        }
    }
    
    //GUI: load movies from remote
    func loadMovies(completionHandler: (NSArray?, NSError?) -> Void)
    {
        let requestManager: RequestManager! = RequestManager.sharedInstance();
        let limit = 10
        let page = movies.count%limit
        requestManager.GET("movies/popular?extended=full,images&page=\(page)&limit=\(limit)", params: nil) { (data, response, error) -> Void in
            if error == nil {
                
                do{
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    self.buildListFromJSONObject(jsonObject)
                }
                catch {
                    
                }
                
            }
            else
            {
                NSLog("Error %@", (error?.localizedDescription)!);
            }
        }
    }
    
    //GUI: clear all entries and reload data
    func reloadMovies(completionHandler: (NSArray?, NSError?) -> Void)
    {
        movies.removeAllObjects();
        loadMovies(completionHandler);
    }
    
}
