//
//  MovieListTableViewController.swift
//  TraktTvTest
//
//  Created by Guglielmo on 14/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var lastPage: NSInteger = 1;
    var movieCount: NSInteger = 0;
    let moviePerPage: NSInteger = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        

        //GUI: load first bunch of movies
        let movieManager = MovieManager.sharedInstance()
        lastPage = 1
        movieManager.loadMovies(moviePerPage, page: lastPage, completionHandler: { (error: NSError?) -> Void in
            NSLog("Load completed: show results");
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.mainTableView.reloadData()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableCells()
    {
        var list = [NSIndexPath]()
        let previousCount = movieCount
        movieCount = MovieManager.sharedInstance().movieCount()
        let diff = movieCount - previousCount
        if(diff > 0)
        {
            for var i = 0; i < diff; i++ {
                let indexPath: NSIndexPath = NSIndexPath(forRow: previousCount + i, inSection: 0)
                list.append(indexPath)
            }
            mainTableView.beginUpdates()
            mainTableView.insertRowsAtIndexPaths(list, withRowAnimation: UITableViewRowAnimation.None)
            mainTableView.endUpdates()
        }
    }

    //GUI:Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        movieCount = MovieManager.sharedInstance().movieCount()
        return movieCount;
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //GUI: dequeue custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier("it.guglielmodeletis.traktv.cell", forIndexPath: indexPath) as! MovieTableViewCell
        //GUI: show movie's info
        let movie: Movie? = MovieManager.sharedInstance().movie(indexPath.row)
        cell.showMovie(movie)
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView,
        willDecelerate decelerate: Bool)
    {
        //GUI: check edge to load new entries
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            
            scrollView.scrollEnabled = false
            //GUI: load another bunch of movies
            loadingView.startAnimating()
            let movieManager = MovieManager.sharedInstance()
            lastPage++;
            movieManager.loadMovies(moviePerPage, page: lastPage, completionHandler: { (error: NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    self.loadingView.stopAnimating()
                    self.updateTableCells()
                    scrollView.scrollEnabled = true
                })
            })
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
