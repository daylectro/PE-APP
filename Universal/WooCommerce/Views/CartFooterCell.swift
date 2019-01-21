//
// Copyright (C) 2015 Twitter, Inc. and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//         http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

final class CartFooterCell: UIView {

    // MARK: Properties

    @IBOutlet private weak var totalItemsLabel: UILabel!

    @IBOutlet private weak var totalPriceLabel: UILabel!

    @IBOutlet private weak var payButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        payButton.layer.masksToBounds = false
        payButton.layer.cornerRadius = 6

        //self.contentView.drawTopBorderWithColor(color: UIColor.brown, height: 0.5)
    }

    func configureWithCart(cart: Cart) {
        // Assign the labels. 
        if (cart.productCount() > 1) {
            totalItemsLabel.text = "\(cart.productCount()) " + NSLocalizedString("items", comment: "")
        } else {
            totalItemsLabel.text = NSLocalizedString("item_one", comment: "")
        }
        totalPriceLabel.text = formatPrice(value:cart.totalAmount())
    }

}

extension UIView {
    // Draw a border at the top of a view.
    func drawTopBorderWithColor(color: UIColor, height: CGFloat) {
        let topBorder = CALayer()
        topBorder.backgroundColor = color.cgColor
        topBorder.frame = CGRect(origin: .zero, size: CGSize(width: self.bounds.width, height: height))
        self.layer.addSublayer(topBorder)
    }
}

