//
//  ViewController.swift
//  CustomSegmentedSections
//
//  Created by vamsi krishna reddy kamjula on 10/19/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

class HomeVC: UIViewController, TwicketSegmentedControlDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {

    // MARK: - Outlets
    @IBOutlet weak var customSegmentCntrl: TwicketSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let articleCellIdentifier = "articleCell"
    
    var openingFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        customSegmentCntrl.delegate = self
        customSegmentCntrl.setSegmentItems(["New", "Top", "Fun"])
        self.getArticlesDataByUrl(BUSINESS_URL)
    }

    func didSelect(_ segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            self.getArticlesDataByUrl(BUSINESS_URL)
        case 1:
            self.getArticlesDataByUrl(TOP_STORIES_URL)
        case 2:
            self.getArticlesDataByUrl(ENTERTAINMENT_URL)
        default:
            return
        }
    }
    
    func getArticlesDataByUrl(_ url: String) {
        DataService.instance.getArticleData(urlString: url) { (success) in
            if success {
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.collectionView.reloadData()
            } else {
                self.somethingWentWrongAlert()
            }
        }
    }
    
    func somethingWentWrongAlert() {
        let alert = UIAlertController.init(title: "Something Went Wrong !!!", message: "Try Again", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: articleCellIdentifier, for: indexPath) as? ArticleCell {
            let article = DataService.instance.articles[indexPath.row]
            cell.configureCell(article)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Set frame of cell
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributeFrames = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributeFrames!, from: collectionView.superview)
        openingFrame = frameToOpenFrom
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
//        // Present view controller
//        let expandedVC = ExpandedVC()
//        expandedVC.transitioningDelegate = self
//        expandedVC.modalPresentationStyle = .custom
//        expandedVC.title = DataService.instance.articles[indexPath.row].title
//        present(expandedVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let detailsVC = segue.destination as! ExpandedVC
            detailsVC.transitioningDelegate = self
            detailsVC.modalPresentationStyle = .custom
        }
    }
    
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = ExpandAnimator.animator
        presentationAnimator.openingFrame = openingFrame!
        presentationAnimator.transitionMode = .Present
        return presentationAnimator as? UIViewControllerAnimatedTransitioning
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = ExpandAnimator.animator
        presentationAnimator.openingFrame = openingFrame!
        presentationAnimator.transitionMode = .Dismiss
        return presentationAnimator as? UIViewControllerAnimatedTransitioning
    }
    
}

