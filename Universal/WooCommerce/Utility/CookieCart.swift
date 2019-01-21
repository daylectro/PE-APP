//
//  CookieCart.swift
//  Universal
//
//  Created by Mark on 24/03/2018.
//  Copyright © 2018 Sherdle. All rights reserved.
//

import Foundation
import Alamofire

private let alamofireManager: SessionManager = NetworkManager.init().manager!

class CookieCart {
    
    private let cart = Cart.sharedInstance
    
    //TODO Preferably, this would be a private instance, since clearing this clears all cookies throughout the app
    public static let cartCookies = HTTPCookieStorage.shared
    private var completion: (_ result: Bool)->()
    
    init(completion: @escaping (_ result: Bool)->()) {
        self.completion = completion
    }
    
    public func getCookiesForCart() {
        //Delete all cookies
        CookieCart.cartCookies.removeCookies(since: Date.distantPast)
        
        doIteration()
    }
    
    private func doIteration(){
        if (cart.items.count == 0) {
            completion(true)
        } else {
            let item = cart.items.first!
            makeRequest(item: item)
        }
    }
    
    private func finishIteration(success: Bool){
        if (!success){
            completion(false)
        } else {
            cart.items.removeFirst()
            doIteration()
        }
    }
    
    private func makeRequest(item: CartItem) {
        
        let productIdToAdd = (item.variation != nil) ? item.variation!.id : item.product.id
        let url = AppDelegate.wooHost() + "?add-to-cart=" + String(describing: productIdToAdd!)
            + "&quantity=" + String(describing: item.quantity)
        print("Requesting: ", url)
        
        alamofireManager.session.configuration.httpCookieStorage  = CookieCart.cartCookies

        alamofireManager.request(url).responseString { response in
            
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.response?.allHeaderFields as! [String : String], for: (response.request?.url)!)
            CookieCart.cartCookies.setCookies(cookies, for: (response.request?.url)!, mainDocumentURL: nil)
            
            self.finishIteration(success: response.result.isSuccess)
        }
    }
    
}
