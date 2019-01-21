//
//  WooCommerceViewController.swift
//  Universal
//
//  Created by Mark on 03/03/2018.
//  Copyright © 2018 Sherdle. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

@objc final class WooCommerceViewController: UICollectionViewController, UISearchBarDelegate{
    
    @objc var params: NSArray!
    var estimateWidth = 140.0
    var cellMarginSize = 1.0
    
    var page = 1
    var canLoadMore = true
    var query: String?
    
    var refresher: UIRefreshControl?
        
    var items = [WooProduct]()
    
    var footerView: FooterView?
    var headerView: CategorySlider?
    var searchButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var cartButton: UIBarButtonItem?
    var searchBar: UISearchBar?
    
    //TODO First request frequently times out ..
    //Hyphotheses: This is a server-side problem.
    //This appears to be the case only if oAuth is used
    /**
 Optional(Error Domain=NSURLErrorDomain Code=-1001 "The request timed out." UserInfo={NSUnderlyingError=0x600000443780 {Error Domain=kCFErrorDomainCFNetwork Code=-1001 "(null)" UserInfo={_kCFStreamErrorCodeKey=-2102, _kCFStreamErrorDomainKey=4}}, NSErrorFailingURLStringKey=http://woocommercebackend.azurewebsites.net/wp-json/wc/v2/products/categories?limit=25, NSErrorFailingURLKey=http://woocommercebackend.azurewebsites.net/wp-json/wc/v2/products/categories?limit=25, _kCFStreamErrorDomainKey=4, _kCFStreamErrorCodeKey=-2102, NSLocalizedDescription=The request timed out.})
 **/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let url = URL(string: AppDelegate.wooHost())
        let key = AppDelegate.wooKey()
        let secret = AppDelegate.wooSecret()
        WooOS.init(url: url!, key: key!, secret: secret!)
        
        setupSearch()
        setupRefresh()
        loadProducts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGridView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout() // layout update
        }, completion: nil)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProduct" {
            if let nextViewController = segue.destination as? ProductDetailViewController{
                nextViewController.product = self.items[(self.collectionView?.indexPathsForSelectedItems![0].item)!]
            }
        } else if segue.identifier == "showCategory"{
            if let nextViewController = segue.destination as? WooCommerceViewController{
                nextViewController.params = [String(describing: headerView!.selectedCategory().id!)]
                nextViewController.title = headerView!.selectedCategory().name;
            }
        }
    }
    
    func setupSearch() {
        searchButton = UIBarButtonItem.init(barButtonSystemItem:UIBarButtonSystemItem.search, target: self, action: #selector(searchClicked))
    
        initCartButton()

        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItems = [cartButton!, searchButton!]
        
        cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(searchBarCancelButtonClicked))
        
        searchBar = UISearchBar.init()
        self.searchBar?.searchBarStyle = UISearchBarStyle.default
        self.searchBar?.placeholder = NSLocalizedString("search", comment: "")
        self.searchBar?.delegate = self
    }
    
    func initCartButton(){
        //let button = UIButton()
        //button.setImage(UIImage(named: "cart"), for: .normal)
        //button.addTarget(self, action: #selector(cartClicked), for: .touchUpInside)
        //cartButton = UIBarButtonItem(customView: button)
        cartButton = UIBarButtonItem.init(image: UIImage(named: "cart"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(cartClicked))
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        if #available(iOS 11.0, *) {
           flow.sectionInsetReference = .fromSafeArea
        }

        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    func setupRefresh(){
        self.collectionView!.alwaysBounceVertical = true
        refresher = UIRefreshControl()
        refresher!.addTarget(self, action: #selector(refreshCalled), for: .valueChanged)
        collectionView!.refreshControl = refresher;
    }
    
    // tell the collection view how many cells to make
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath)
        if let annotateCell = cell as? ProductCell {
            annotateCell.product = self.items[indexPath.item]
        }
        
        if indexPath.item == items.count - 1 && canLoadMore {
            loadProducts()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                       withReuseIdentifier: "Footer", for: indexPath) as? FooterView
            footerView?.activityIndicator.startAnimating()
            return footerView!
        case UICollectionElementKindSectionHeader:
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                       withReuseIdentifier: "Header", for: indexPath) as? CategorySlider
            if (params.count == 0 || (params[0] as! String).isEmpty){
                headerView?.loadCategories()
            }
            return headerView!
        default:
            assert(false, "Unexpected element kind")
        }
        
        //Satisfy damn constraints
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         if (params.count == 0 || (params[0] as! String).isEmpty) {
            return CGSize(width: collectionView.frame.width, height: 125)
        } else {
            return CGSize.zero
        }
    }
    
    @objc func refreshCalled() {
        reset()
        self.collectionView?.reloadData()
        loadProducts()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func loadProducts() {
        
        var requestParams: [WooProductRequestParameter] = [WooProductRequestParameter.page(self.page)]
        if ((query) != nil) {
            requestParams.append(WooProductRequestParameter.search(query!))
        }
        if (params.count > 0 && !(params[0] as! String).isEmpty){
            requestParams.append(WooProductRequestParameter.category(params[0] as! String))
        }
        
        WooProduct.getList(with: requestParams) { (success, results, error) in
            if let error = error {
                print("result: ", results ?? "");
                print("Error searching : \(error)")
                
                if (self.items.count == 0) {
                    let alertController = UIAlertController.init(title: NSLocalizedString("error", comment: ""), message: NO_CONNECTION_TEXT, preferredStyle: UIAlertControllerStyle.alert)
                
                    let ok = UIAlertAction.init(title: NSLocalizedString("ok", comment: ""), style: UIAlertActionStyle.default, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.footerView?.isHidden = true
                }
                
                return
            }
            
            if let results = results {
                self.items += results
                
                if (results.count == 0) {
                    self.canLoadMore = false
                    self.footerView?.isHidden = true
                }
                
                self.collectionView?.reloadData()
                self.refresher?.endRefreshing()
                
                self.page += 1
            }
            
        }
    }
    
    @objc func cartClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cartController = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(cartController, animated: true)
    }
    
    @objc func searchClicked() {
        //[self setPullToRefreshEnabled:false];
        searchBar?.resignFirstResponder()
        searchButton?.isEnabled = false
        searchButton?.tintColor = UIColor.clear
        
        self.navigationItem.rightBarButtonItems = [cartButton!, cancelButton!]
        cancelButton?.tintColor = nil
        
        self.navigationItem.titleView = searchBar
        searchBar?.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            self.searchBar?.alpha = 1.0
        }
        searchBar?.becomeFirstResponder()
    }
    
    @objc func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //[self setPullToRefreshEnabled:true];
        
        UIView.animate(withDuration: 0.2, animations: {
            self.searchBar?.alpha = 0.0
            self.cancelButton?.tintColor = UIColor.clear
        }, completion:{ _ in
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItems = [self.cartButton!, self.searchButton!]
            UIView.animate(withDuration: 0.2, animations: {
                self.searchButton?.isEnabled = true
                self.searchButton?.tintColor = nil
            })
        })
        //Show footerView
        
        //Reset
        reset()
        
        query = nil
        loadProducts()
        self.collectionView?.reloadData()
    }
    
    @objc func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reset()
        
        query = searchBar.text
        loadProducts()
        self.collectionView?.reloadData()
    }
    
    func reset(){
        items.removeAll()
        page = 1
        canLoadMore = true
        footerView?.isHidden = false
    }
    
}

extension WooCommerceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width * CGFloat(ProductCell.widthHeightRatio))
    }
    
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}

