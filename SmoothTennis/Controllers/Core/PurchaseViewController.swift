//
//  PurchaseViewController.swift
//  Instagram
//
//  Created by Jeffrey Liang on 2022/7/27.
//
import StoreKit
import UIKit

class PurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver
    {
    
    
    private var models = [SKProduct]()

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        fetchProducts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "HometoPurchase") {
            self.tabBarController?.tabBar.isHidden = true
        }
        UserDefaults.standard.setValue(false, forKey: "HometoPurchase")
    }
    
    //Table
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = CGRect(x: 50, y: 50, width: view.width, height: 400)
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(product.localizedTitle): \(product.localizedDescription) - \(product.priceLocale.currencySymbol ?? "$")\((product.price))"
        if indexPath.row == 0 {
            cell.backgroundColor = .systemBlue
        }
        if indexPath.row == 1 {
            cell.backgroundColor = .systemGreen
        }
        if indexPath.row == 2 {
            cell.backgroundColor = .systemPink
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// Show Purchase
        let payment = SKPayment(product: models[indexPath.row])
        SKPaymentQueue.default().add(payment)
    }

    // Products

    enum Product: String, CaseIterable {
        case tenPs = "com.myapp.getTenPs"
        case fiftyPs = "com.myapp.getFiftyPs"
        case hundredPs = "com.myapp.getHundredPs"
    }

    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print("Count: \(response.products.count)")
            self.models = response.products
            self.tableView.reloadData()
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {

            case .purchasing:
                print("purchasing")
            case .purchased:
                //print("purchased")
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                //print("did not purchase")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
}
