//
//  MoviesManager.swift
//  TraktTvTest
//
//  Created by Guglielmo on 14/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//
//  GUI: manager singleton class - loads and stores movies

import UIKit
import CoreData

class MovieManager: NSObject {
    
    static var singleton: MovieManager? = nil
    
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
            //GUI: get count of current movies in db
            var count = movieCount();
            //GUI: build models and save them into db
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let list: NSArray! = jsonObject as! NSArray
            for infoItem in list
            {
                let item:NSDictionary! = infoItem as! NSDictionary
                let entity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext:managedContext!)
                let movie = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                movie.setValue(item["title"], forKey: "title")
                movie.setValue(item["year"], forKey: "year")
                movie.setValue(item["overview"], forKey: "overview")
                movie.setValue(count, forKey: "index")
                //GUI: get images from data
                let images: NSDictionary? = item["images"] as? NSDictionary
                let banner: NSDictionary? = images?["banner"] as? NSDictionary
                let bannerFull = banner?["full"]
                if bannerFull is NSString {movie.setValue(bannerFull, forKey: "banner")}
                let poster: NSDictionary? = images?["poster"] as? NSDictionary
                let posterFull = poster?["full"]
                if posterFull is NSString {movie.setValue(posterFull, forKey: "poster")}
                //GUI: update count
                count++
            }
            
            do{
                try managedContext?.save()
            }
            catch let error as NSError{
                NSLog("Error %@", error.localizedDescription)
            }
        }
    }
    
    //GUI: load movies from remote
    func loadMovies(limit: NSInteger, page: NSInteger, completionHandler: (NSError?) -> Void)
    {
        let requestManager: RequestManager! = RequestManager.sharedInstance();
        requestManager.GET("\(requestManager.baseURL)movies/popular?extended=full,images&page=\(page)&limit=\(limit)", params: nil) { (data, response, error) -> Void in
            if error == nil {
                
                do{
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    self.buildListFromJSONObject(jsonObject)
                    completionHandler(nil)
                }
                catch {
                    
                }
                
            }
            else
            {
                NSLog("Error %@", (error?.localizedDescription)!)
                completionHandler(error)
            }
        }
    }
    
    //GUI: clear all entries and reload data
    func reloadMovies(limit: NSInteger, completionHandler: (NSError?) -> Void)
    {
        clear()
        loadMovies(limit, page: 1, completionHandler: completionHandler);
    }
    
    func clear()
    {
        //GUI: clear DB
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Movie")
        var list = [AnyObject]()
        
        do{
            try list = managedContext!.executeFetchRequest(request)
            for movie: AnyObject in list
            {
                managedContext?.deleteObject(movie as! NSManagedObject)
            }
            
            try managedContext?.save()
        }
        catch let error as NSError{
            NSLog("Error %@", (error.localizedDescription))
        }
    }
    
    func movieCount() -> NSInteger
    {
        //GUI: count movie entries in DB
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Movie")
        var list = [AnyObject]()
        var count = 0;
        
        do{
            try list = managedContext!.executeFetchRequest(request)
            count = list.count
        }
        catch let error as NSError{
            NSLog("Error %@", (error.localizedDescription))
        }
        
        return count
    }
    
    func movie(index: NSInteger) -> Movie?
    {
        //GUI: get movie entry in DB by index
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Movie")
        let predicate = NSPredicate(format: "index = %d", index)
        request.predicate = predicate
        var list = [AnyObject]()
        var movie: Movie? = nil
        do{
            try list = managedContext!.executeFetchRequest(request)
            if list.count > 0
            {
                movie = list[0] as? Movie
            }
        
        }
        catch let error as NSError{
            NSLog("Error %@", (error.localizedDescription))
        }
        
        return movie
    }
    
}
