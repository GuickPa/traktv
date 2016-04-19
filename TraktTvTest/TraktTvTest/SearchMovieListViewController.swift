//
//  SearchMovieListViewController.swift
//  TraktTvTest
//
//  Created by Guglielmo on 18/04/16.
//  Copyright © 2016 Guglielmo Deletis. All rights reserved.
//

import UIKit

class SearchMovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mainSearchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var mainPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesBegan(touches, withEvent: event)
        mainSearchBar.resignFirstResponder()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //GUI: force collectionview to layout
        self.mainCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func onTapOutsideKeyboard(sender: AnyObject) {
        if mainSearchBar.isFirstResponder(){
            mainSearchBar.resignFirstResponder()
        }
    }
    // MARK: - Search functions
    private func searchWithQuery(query: NSString)
    {
        if query.length > 0{
            self.loadingView.startAnimating()
            MovieManager.sharedInstance().searchForMovies(query) { (error: NSError?) -> Void in
                if error != nil
                {
                    NSLog("Error in search: %@", error!.localizedDescription)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let count = MovieManager.sharedInstance().movieResultsCount()
                    if count > 0 {
                        self.mainPageControl.hidden = false
                        self.mainCollectionView.hidden = false
                        self.mainPageControl.numberOfPages = count
                    }
                    else
                    {
                        self.mainPageControl.hidden = true
                        self.mainCollectionView.hidden = true
                    }
                    self.mainCollectionView.reloadData()
                    self.loadingView.stopAnimating()
                })
            }
        }
        else
        {
            MovieManager.sharedInstance().clearMovieResults()
            self.mainPageControl.hidden = false
            self.mainCollectionView.hidden = false
            self.mainCollectionView.reloadData()
        }
    }
    
    //MARK: - Search on events
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchWithQuery(mainSearchBar.text!)
        mainSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchWithQuery(mainSearchBar.text!)
        mainSearchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchWithQuery(searchText)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return MovieManager.sharedInstance().movieResultsCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = mainCollectionView.dequeueReusableCellWithReuseIdentifier("it.guglielmodeletis.traktv.cell.result", forIndexPath: indexPath) as! MovieResultCollectionViewCell
        
        let movie: Movie? = MovieManager.sharedInstance().movieResult(indexPath.row)
        cell.showMovieResult(movie)
        
        return cell
        
    }
    
    //MARK: - flowLayoutDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let size:CGSize = mainCollectionView.frame.size
        return size
    }
    
    //MARK: - scrollviewdelegate
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let count: CGFloat = CGFloat(MovieManager.sharedInstance().movieResultsCount())
        //GUI: update page control
        if scrollView.contentSize.width > 0
        {
            let page: Int = Int((scrollView.contentOffset.x/scrollView.contentSize.width) * count)
            mainPageControl.currentPage = page
        }
        //GUI: if user scrolls while keyboard is up
        if mainSearchBar.isFirstResponder(){
            mainSearchBar.resignFirstResponder()
        }
    }
}
