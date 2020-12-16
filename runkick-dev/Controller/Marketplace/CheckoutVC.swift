//
//  CheckoutVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/25/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFunctions
import Stripe
import MessageUI

private let reuseIdentifier = "Cell"

class CheckoutVC: UIViewController, CheckoutCellDelegate, MFMailComposeViewControllerDelegate {
    
    // Mark: - Variables
    
    var tableView: UITableView!
    var paymentContext: STPPaymentContext!  // implicitlly unwrapped
    
    // Mark: - Properties
    
    let separatorView: UIView = {
           let view = UIView()
           //view.layer.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).cgColor
           view.layer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
           return view
       }()

    
    let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Payment Method"
        return label
    }()
    
    lazy var paymentMethodOption: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(handlePaymentMethodTapped), for: .touchUpInside)
        button.setTitle("Payment Option", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.rgb(red: 90, green: 90, blue: 90), for: .normal)
        button.layer.borderColor = UIColor.rgb(red: 0, green: 0, blue: 0).cgColor
        button.layer.borderWidth = 0.25
        button.alpha = 1
        button.backgroundColor = .clear
        return button
    }()
    
    let redeemedPointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Points Redeemed"
        return label
    }()
    
    let redeemedTotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "720"
        return label
    }()
    
    
    let separatorView2: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        //view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        return view
    }()
    
    let subtotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Subtotal"
        return label
    }()
    
    let subtotalCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "$0.00"
        return label
    }()
    
    let processingFeeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Processing Fee"
        return label
    }()
    
    let processingCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "$0.00"
        return label
    }()
    
    let totalSavedLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Total Saved"
        return label
    }()
    
    let savedCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "$0.00"
        return label
    }()
    
    
    let separatorView3: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        //view.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        return view
    }()
    
    let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Total"
        return label
    }()
    
    let totalAmountCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "$0.00"
        return label
    }()
    
    lazy var placeOrderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // add gesture recognizer
        label.text = "PLACE ORDER"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        let messageTap = UITapGestureRecognizer(target: self, action: #selector(handlePlaceOrder))
        messageTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(messageTap)
        return label
    }()
    
    lazy var shadowBackground: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.35).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        let messageTapped = UITapGestureRecognizer(target: self, action: #selector(handlePlaceOrder))
        messageTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(messageTapped)
        return view
    }()
    
    lazy var placeOrderBackground: GradientActionView = {
        let view = GradientActionView()
        let messageTapped = UITapGestureRecognizer(target: self, action: #selector(handlePlaceOrder))
        messageTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(messageTapped)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        configureTableView()
        
        configureViewComponents()
        
        configureTabBar()
        
        setupStripeConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {    
        configureTabBar()
    }
    
    
    func configureTableView() {
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CheckoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // disables the scrolling feature for the table view
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        //tableView.rowHeight = 100

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 260)
        
        setupPaymentInfo()
    }
    
    func setupPaymentInfo() {
        
        // calling pennies to formatted currency to get a properly formatted string
        subtotalCostLabel.text = StripeCart.subtotal.penniesToFormatttedCurrency()
        processingCostLabel.text = StripeCart.processingFees.penniesToFormatttedCurrency()
        totalAmountCostLabel.text = StripeCart.total.penniesToFormatttedCurrency()
        
    }
    
    func sendStoreEmail() {
        
        // will need to gather all order data from either strip or while collecting from cart
        
        // may have to look at strip cart, tableview has the array of cart items. need to find gather items and total and send in email
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["cameron.frasier@gmail.com"])
            mail.setMessageBody("<p>Here is what was ordered and the user will arrive in 15mins!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            print("this user cannot send email for some reason")
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func configureViewComponents() {
        
        view.addSubview(separatorView)
        separatorView.anchor(top: tableView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0.30)
        

        
        let stackView = UIStackView(arrangedSubviews: [paymentMethodLabel, redeemedPointsLabel])
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.anchor(top: separatorView.bottomAnchor, left: separatorView.leftAnchor, bottom: nil, right: separatorView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 150, width: 0, height: 0)
        
        paymentMethodOption.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 130, height: 30)
        paymentMethodOption.layer.cornerRadius = 15
        
        let stackViewCost = UIStackView(arrangedSubviews: [paymentMethodOption, redeemedTotalLabel])
        
        stackViewCost.axis = .vertical
        stackViewCost.distribution = .equalSpacing
        stackViewCost.alignment = .trailing
        stackViewCost.spacing = 8
        stackViewCost.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackViewCost)
        stackViewCost.anchor(top: stackView.topAnchor, left: stackView.rightAnchor, bottom: nil, right: separatorView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(separatorView2)
        separatorView2.anchor(top: stackView.bottomAnchor, left: separatorView.leftAnchor, bottom: nil, right: separatorView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.30)
        
        let stackView2 = UIStackView(arrangedSubviews: [subtotalLabel, processingFeeLabel, totalSavedLabel])
        
        stackView2.axis = .vertical
        stackView2.distribution = .equalSpacing
        stackView2.alignment = .leading
        stackView2.spacing = 15
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView2)
        stackView2.anchor(top: separatorView2.bottomAnchor, left: separatorView.leftAnchor, bottom: nil, right: separatorView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 100, width: 0, height: 0)
        
        let stackView2Cost = UIStackView(arrangedSubviews: [subtotalCostLabel, processingCostLabel, savedCostLabel])
        
        stackView2Cost.axis = .vertical
        stackView2Cost.distribution = .equalSpacing
        stackView2Cost.alignment = .trailing
        stackView2Cost.spacing = 15
        stackView2Cost.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView2Cost)
        stackView2Cost.anchor(top: stackView2.topAnchor, left: stackView2.rightAnchor, bottom: nil, right: separatorView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(separatorView3)
        separatorView3.anchor(top: stackView2.bottomAnchor, left: separatorView.leftAnchor, bottom: nil, right: separatorView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.30)
        
        view.addSubview(totalAmountLabel)
        totalAmountLabel.anchor(top: separatorView3.bottomAnchor, left: separatorView.leftAnchor, bottom: nil, right: separatorView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height:0)
        
        view.addSubview(totalAmountCostLabel)
        totalAmountCostLabel.anchor(top: totalAmountLabel.topAnchor, left: nil, bottom: nil, right: separatorView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
        
        // place order button
        
        view.addSubview(shadowBackground)
        shadowBackground.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 150, height: 45)
        shadowBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shadowBackground.layer.cornerRadius = 23
        
        shadowBackground.addSubview(placeOrderBackground)
        placeOrderBackground.anchor(top: shadowBackground.topAnchor, left: shadowBackground.leftAnchor, bottom: shadowBackground.bottomAnchor, right: shadowBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 130, height: 45)
        placeOrderBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        placeOrderBackground.layer.cornerRadius = 22
        
        placeOrderBackground.addSubview(placeOrderLabel)
        placeOrderLabel.anchor(top: placeOrderBackground.topAnchor, left: placeOrderBackground.leftAnchor, bottom: placeOrderBackground.bottomAnchor, right: placeOrderBackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func configureTabBar() {
        
        // removing shadow from tab bar
        tabBarController?.tabBar.layer.shadowRadius = 0
        tabBarController?.tabBar.layer.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
    }
    
    @objc func handlePlaceOrder() {
        paymentContext.requestPayment()
        
        print("ORDER SHOULD BE PLACED HERE")
        //shouldPresentLoadingView(true)
        
        //sendStoreEmail()
        
    }
    
    
    @objc func handlePaymentMethodTapped() {
        print("Handle payment method tapped")
        paymentContext.pushPaymentOptionsViewController()
    }
    
    func removeItemFromCart(for cell: CheckoutCell, category: Category?) {
        
        print("reload function selected")
        
        // calling our Stripe singleton
        StripeCart.removeItemFromCart(item: category!)
        tableView.reloadData()
        // re-calling setup payment info
        setupPaymentInfo()
        paymentContext.paymentAmount = StripeCart.total
    }
    
    func setupStripeConfig() {
        
        // the stripe configurations holds the customer context, which works directly with the StripeApi class and subsequently the Stripe SDK.
        
        let config = STPPaymentConfiguration.shared()
        //config.createCardSource = true // if the value of the property is true when a user adds a card in our UI, then a card source will be created and added to our Stripe customer. We want it to be true so when user enters in their card information then it gets saved to their card object. set to false by default.
        
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = .none
        //config.requiredShippingAddressFields = [.postalAddress]//may not need this at all
        
        
        // this class will pre fetch all of the customer information shipping info, etc.
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        paymentContext.paymentAmount = StripeCart.total
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
}

extension CheckoutVC: STPPaymentContextDelegate {

    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        // updating the selected payment method on the UI
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodOption.setTitle(paymentMethod.label, for: .normal)
            paymentMethodOption.setTitleColor(UIColor.rgb(red: 0, green: 0, blue: 0), for: .normal)
        } else {
            paymentMethodOption.setTitle("Select Method", for: .normal)
        }
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
        //activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
    
        // we need to also send information to firebase
        
        print("DEBUG: WE GET HERE AFTER PRESSING PLACE ORDER")
               
               // STEP 1 - send up the total, customer id etc. then go to STEP 2 - Cloud function
               
               guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
               DataService.instance.REF_USERS.child(currentUid).child("stripeId").observeSingleEvent(of: .value) { (snapshot) in
                       let stripeId = snapshot.value as! String
               
                        
                           // replacing string dashes with nothing below
                           let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                            
                        // we send up the total stripeId and idempotency
                           let data : [String: Any] = [
                           "total_amount" : StripeCart.total,
                           "customer_id" : stripeId,
                           "payment_method_id" : paymentResult.paymentMethod?.stripeId ?? "",
                           "idempotency" : idempotency
                           ]
               
                   Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
                    
                           if let error = error {
                            debugPrint(error.localizedDescription)
                            //self.simpleAlert(title: "Error", msg: "Unable to make charge")
                            completion(STPPaymentStatus.error, error)
                               return
                           }
                
                           StripeCart.clearCart()
                           self.tableView.reloadData()
                           self.setupPaymentInfo()
                        completion(.success, nil)
                       }
               }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        // STEP 3 - after cloud function this should tell us good or no.
        
        let title: String
        let message: String
        
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success!"
            message = "Thank you for your purchase."
        case .userCancellation:
            return
        }
        
        let alertController  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        }
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CheckoutCell
        
        let product = StripeCart.cartItems[indexPath.row]
        cell.configureCell(product: product, delegate: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

