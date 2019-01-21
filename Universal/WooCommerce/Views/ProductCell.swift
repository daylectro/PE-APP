/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import SDWebImage

class ProductCell: UICollectionViewCell {
  
  public static var widthHeightRatio = 1.5
    
  @IBOutlet fileprivate weak var containerView: UIView!
  @IBOutlet fileprivate weak var imageView: UIImageView!
  @IBOutlet fileprivate weak var captionLabel: UILabel!
  @IBOutlet fileprivate weak var commentLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }
  
  var product: WooProduct? {
    didSet {
      if let product = product {
        if (product.images?.isEmpty == false) {
            imageView.sd_setImage(with: product.images?[0].src);
        } 
        captionLabel.text = product.name!
        commentLabel.text = formatPrice(value: product.price!)
        if product.price! < product.regularPrice! {
            let retailPriceString = formatPrice(value: product.regularPrice!)
            let currentPriceString = formatPrice(value: product.price!)
            let attributedPrice = NSMutableAttributedString(string: retailPriceString + " " + currentPriceString)
            attributedPrice.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, retailPriceString.count))
            attributedPrice.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.red, range: NSMakeRange(0, retailPriceString.count))
            commentLabel.attributedText = attributedPrice
        }
      }
    }
  }

  
}
