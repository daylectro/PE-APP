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

final class CartItemCell: UITableViewCell {

    static let reuseIdentifier = "CartItemCell"

    var cartItemQuantityChangedCallback: (() -> ())!

    private weak var cartItem: CartItem!

    // MARK: Properties

    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var priceLabel: UILabel!

    @IBOutlet private weak var quantityLabel: UILabel!

    @IBOutlet private weak var quantityStepper: UIStepper!

    @IBOutlet private weak var availabilityLabel: UILabel!

    @IBOutlet private weak var productImageView: UIImageView!

    // MARK: IBActions

    @IBAction func quantityStepperValueChanged(_ sender: Any) {
        let value = Int((sender as! UIStepper).value)
        let updateSuccesfull = Cart.sharedInstance.updateQuantity(item: cartItem, value: value)
        if (updateSuccesfull) {
            quantityLabel.text = NSLocalizedString("quantity", comment: "") + ": \(value)"
            cartItemQuantityChangedCallback()
        }
    }
    
    override func awakeFromNib() {
        // Resize the stepper.
        quantityStepper.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        // Draw a border layer at the top.
        //self.drawTopBorderWithColor(color: UIColor.brown, height: 0.5)
    }

    func configureWithCartItem(cartItem: CartItem) {
        self.cartItem = cartItem

        // Assign the labels.
        nameLabel.text = cartItem.product.name
        priceLabel.text = formatPrice(value: cartItem.price)
        availabilityLabel.text = (cartItem.variation != nil) ? getVariationDescription(variation: cartItem.variation!) : cartItem.product.categories?.first?.name
        quantityLabel.text = NSLocalizedString("quantity", comment: "") + ": \(cartItem.quantity)" 
        quantityStepper.value = Double(cartItem.quantity)

        // Load the image from the network and give it the correct aspect ratio.
        if (cartItem.product.images?.isEmpty == false) {
            productImageView.sd_setImage(with: cartItem.product.images?[0].src);
        }
    }
    
    func getVariationDescription(variation: WooProductVariation) -> String{
        var attributes = [String]()
        for attribute in variation.attributes! {
            attributes.append(attribute.name! + ": " + attribute.option!)
        }
        return attributes.joined(separator: ", ")
    }
}
