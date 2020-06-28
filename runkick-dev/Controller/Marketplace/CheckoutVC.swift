//
//  CheckoutVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/25/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class CheckoutVC: UIViewController {
    
    // Mark: - Properties
    var tableView: UITableView!
    
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
    
    let paymentMethodOption: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Payment Option"
        return label
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
        
        view.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
        
        configureTableView()
        
        configureViewComponents()
        
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
        //tableView.separatorStyle = .none
        //tableView.rowHeight = 100

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 200)
        
    }
    
    func configureViewComponents() {
        
        view.addSubview(separatorView)
        separatorView.anchor(top: tableView.bottomAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.30)
        
        let stackView = UIStackView(arrangedSubviews: [paymentMethodLabel, redeemedPointsLabel])
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.anchor(top: separatorView.bottomAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 150, width: 0, height: 0)
        
        let stackViewCost = UIStackView(arrangedSubviews: [paymentMethodOption, redeemedTotalLabel])
        
        stackViewCost.axis = .vertical
        stackViewCost.distribution = .equalSpacing
        stackViewCost.alignment = .trailing
        stackViewCost.spacing = 15
        stackViewCost.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackViewCost)
        stackViewCost.anchor(top: stackView.topAnchor, left: stackView.rightAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(separatorView2)
        separatorView2.anchor(top: stackView.bottomAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.30)
        

        
        let stackView2 = UIStackView(arrangedSubviews: [subtotalLabel, processingFeeLabel, totalSavedLabel])
        
        stackView2.axis = .vertical
        stackView2.distribution = .equalSpacing
        stackView2.alignment = .leading
        stackView2.spacing = 15
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView2)
        stackView2.anchor(top: separatorView2.bottomAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 100, width: 0, height: 0)
        
        let stackView2Cost = UIStackView(arrangedSubviews: [subtotalCostLabel, processingCostLabel, savedCostLabel])
        
        stackView2Cost.axis = .vertical
        stackView2Cost.distribution = .equalSpacing
        stackView2Cost.alignment = .trailing
        stackView2Cost.spacing = 15
        stackView2Cost.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView2Cost)
        stackView2Cost.anchor(top: stackView2.topAnchor, left: stackView2.rightAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(separatorView3)
        separatorView3.anchor(top: stackView2.bottomAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.30)
        
        view.addSubview(totalAmountLabel)
        totalAmountLabel.anchor(top: separatorView3.bottomAnchor, left: separatorView.leftAnchor, bottom: nil, right: separatorView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height:0)
        
        view.addSubview(totalAmountCostLabel)
        totalAmountCostLabel.anchor(top: totalAmountLabel.topAnchor, left: nil, bottom: nil, right: tableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
        
        // place order button
        
        view.addSubview(shadowBackground)
        shadowBackground.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 40, paddingRight: 0, width: 150, height: 45)
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
        print("Place order now")
    }
    
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CheckoutCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

