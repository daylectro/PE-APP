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
import Alamofire
import LPSnackbar

final class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartFooter: CartFooterCell!
    private let cart = Cart.sharedInstance

    override func awakeFromNib() {
        super.awakeFromNib()

        // Listen to notifications about the cart being updated.
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCartDisplay), name: NSNotification.Name(rawValue: Cart.cartUpdatedNotificationName), object: self.cart)
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        cartFooter.configureWithCart(cart: cart)

        // Put a label as the background view to display when the cart is empty.
        let emptyCartLabel = UILabel()
        emptyCartLabel.numberOfLines = 0
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.textColor = UIColor.darkGray
        emptyCartLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        emptyCartLabel.text = NSLocalizedString("cart_empty", comment: "")
        self.tableView.backgroundView = emptyCartLabel
        self.tableView.backgroundView?.isHidden = true
        self.tableView.backgroundView?.alpha = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.reloadData()
        toggleEmptyCartLabel()
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return cart.isEmpty() ? 0 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the cart.
        return cart.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.reuseIdentifier, for: indexPath as IndexPath) as! CartItemCell

        // Find the corresponding cart item.
        let cartItem = cart.items[indexPath.row]

        // Keep a weak reference on the table view.
        cell.cartItemQuantityChangedCallback = { [unowned self] in
            self.refreshCartDisplay()
            self.tableView.reloadData()
            self.cartFooter.configureWithCart(cart: self.cart)
        }

        // Configure the cell with the cart item.
        cell.configureWithCartItem(cartItem: cartItem)

        // Return the cart item cell.
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        // Remove this item from the cart and refresh the table view.
        cart.items.remove(at: indexPath.row)

        // Either delete some rows within the section (leaving at least one) or the entire section.
        if cart.items.count > 0 {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            let set = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(set, with: .fade)
        }
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }

    // MARK: Utilities

    @objc private func refreshCartDisplay() {
        cartFooter.configureWithCart(cart: cart)
        toggleEmptyCartLabel()
    }

    private func toggleEmptyCartLabel() {
        if cart.isEmpty() {
            UIView.animate(withDuration: 0.15) {
                self.tableView.backgroundView!.isHidden = false
                self.cartFooter.isHidden = true
                self.tableView.backgroundView!.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.15,
                animations: {
                    self.tableView.backgroundView!.alpha = 0
                },
                completion: { finished in
                    self.tableView.backgroundView!.isHidden = false
                    self.cartFooter.isHidden = false
                }
            )
        }
    }
}
