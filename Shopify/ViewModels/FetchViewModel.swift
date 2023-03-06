//
//  ViewModel.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Foundation
class BrandViewModel {
    var bindResultOfBrandsToHomeViewController: (() -> Void) = {}

    var DataOfBrands: Brands! {
        didSet {
            bindResultOfBrandsToHomeViewController()
        }
    }

    func getdata(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.DataOfBrands = result
        }
    }
}

class OfferViewModel {
    var bindResultOfOffersToHomeViewController: (() -> Void) = {}

    var DataOfOffers: Discounts! {
        didSet {
            bindResultOfOffersToHomeViewController()
        }
    }

    func getoffer(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.DataOfOffers = result
        }
    }
}

class CatigoriesViewModel {
    var bindResultOfCatigoriesToCatigorieViewController: (() -> Void) = {}

    var DataOfProducts: Products! {
        didSet {
            bindResultOfCatigoriesToCatigorieViewController()
        }
    }

    func getProducts(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.DataOfProducts = result
        }
    }
}

class BrandproductsViewModel {
    var bindResultOfBrandproductToProductdetailsViewController: (() -> Void) = {}

    var DataOfBrandProduct: Products! {
        didSet {
            bindResultOfBrandproductToProductdetailsViewController()
        }
    }

    func getBrandProducts(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.DataOfBrandProduct = result
        }
    }
}

class UserViewModel {
    var bindDataToVC: (() -> Void) = {}
    var users: Customers? {
        didSet {
            bindDataToVC()
        }
    }

    func fetchUsers(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.users = result
        }
    }
}

class OrderViewModel {
    var bindResultToProfileVC: (() -> Void) = {}
    var ordersResult: OrdersResult? {
        didSet {
            bindResultToProfileVC()
        }
    }

    func getOrders(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.ordersResult = result
        }
    }
}

class AddressesFunctions
{
    func deleteCode(target: EndPoints)
    {
        NetworkServices.delete(url: target.path)
    }
    
    func postCode(target: EndPoints, parameters: [String : Any])
    {
        NetworkServices.postMethod(url: target.path, parameters: parameters)
    }
    
    func putCode(target: EndPoints, parameters: [String : Any])
    {
        NetworkServices.putMethod(url: target.path, parameters: parameters)
    }
}
