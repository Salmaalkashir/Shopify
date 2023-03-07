//
//  ProductDetailsVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit
import Cosmos
import Kingfisher

class ProductDetailsVC: UIViewController {
    private var flag : Bool = false
    var  currentcellindex = 0
    var timer : Timer?
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productprice: UILabel!
    @IBOutlet weak var pulldowncolor: UIButton!
    @IBOutlet weak var pulldownsize: UIButton!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var ItemCV: UICollectionView! {
        didSet {
            ItemCV.delegate = self
            ItemCV.dataSource = self
            ItemCV.layer.borderWidth = 2
            ItemCV.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            ItemCV.layer.masksToBounds = true
            ItemCV.layer.cornerRadius = 15
            let nib = UINib(nibName: "BrandCVCell", bundle: nil)
            ItemCV.register(nib,forCellWithReuseIdentifier: "offerbrandcell")
        }
    }
    @IBOutlet var reviewTableView: UITableView! {
        didSet {
            reviewTableView.delegate = self
            reviewTableView.dataSource = self
            reviewTableView.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
            reviewTableView.layer.borderWidth = 1.5
            reviewTableView.layer.cornerRadius = 20
            let nibT = UINib(nibName: "ReviewTVCell", bundle: nil)
            reviewTableView.register(nibT, forCellReuseIdentifier: "reviewTVCell")
        }
    }
    @IBOutlet weak var productdescription: UITextView!
    @IBOutlet weak var favbtn: UIButton!
    
    var detailedProduct : Product?
    
    var cartVM : DraftOrderViewModel?
    var draftOrder : DraftOrderResult?
    var nsDefault = UserDefaults()
    var lineItems : [[String : Any]] = []
    var lineItem : [String : Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        productname.text = detailedProduct?.title
        productprice.text = detailedProduct?.variants?[0].price
        productdescription.text = detailedProduct?.body_html
        pagecontrol.numberOfPages = detailedProduct?.images?.count ?? 0
        productfilter(sender: pulldownsize)
        productfilter(sender: pulldowncolor)
        
        cartVM = DraftOrderViewModel()
    
    }
    
    func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(movetonext), userInfo: nil, repeats: true)
    }
     @objc func movetonext()
   {
       if currentcellindex < (detailedProduct?.images?.count ?? 0)-1
       {
           currentcellindex += 1
       }
       else
       {
           currentcellindex = 0
       }
       ItemCV.scrollToItem(at: IndexPath(item: currentcellindex, section: 0), at: .centeredHorizontally, animated: true)
       pagecontrol.currentPage = currentcellindex
   }

    @IBAction func addtocart(_ sender: Any) {
        
        //6839029793046
        //fatma@gmail.com
        var params : [String : Any] = [
            "draft_order" : [
                "note" : "created",
                "email" : nsDefault.value(forKey: "customerEmail") as? String ?? "",
                "currency" : "EGP",
                "line_items" : [
                    [
                        "title" : detailedProduct?.title ?? "",
                        "vendor" : detailedProduct?.vendor ?? "",
                        "quantity" : 1,
                        "price" : detailedProduct?.variants?[0].price ?? ""
                    ]
                ]
            ]
        ]
        
        if nsDefault.value(forKey: "note") as? String == "first"
        {
            cartVM?.postNewDraftOrder(target: .alldraftOrders, params: params)
            nsDefault.set("created", forKey: "note")
            cartVM?.bindErrorToCartVC = {
                DispatchQueue.main.async {
                    switch self.cartVM?.error?.keys.formatted() {
                    case "draft_order":
                        let draftOrderDict = self.cartVM?.error?["draft_order"] as? [String : Any]
                        self.nsDefault.set(draftOrderDict?["id"] as? Int, forKey: "draftOrderID")
                    case "error":
                        break
                    default :
                        break
                    }
                }
            }
        }else {
            cartVM?.getDraftOrders(target: .draftOrder(id:( nsDefault.value(forKey: "draftOrderID") as? Int)?.formatted() ?? ""))
            cartVM?.bindDraftOrderToCartVC = {
                DispatchQueue.main.async {
                    self.draftOrder = self.cartVM?.draftOrderResults
                    for lineItem in self.draftOrder?.draft_orders?[0].line_items ?? [] {
                        self.lineItem = [
                            "title" : lineItem.title ?? "",
                            "vendor" : lineItem.vendor ?? "",
                            "quantity" : 1,
                            "price" : lineItem.price ?? ""
                        ]
                        self.lineItems.append(self.lineItem ?? [:])
                    }
                }
            }
            lineItem =  [
                "title" : detailedProduct?.title ?? "",
                "vendor" : detailedProduct?.vendor ?? "",
                "quantity" : 1,
                "price" : detailedProduct?.variants?[0].price ?? ""
            ]
            self.lineItems.append(self.lineItem ?? [:])
            
            params = [
                "draft_order" : [
                    "line_items" : [lineItems]
                ]
            ]
            
            cartVM?.editDraftOrder(target: .draftOrder(id:( nsDefault.value(forKey: "draftOrderID") as? Int)?.formatted() ?? ""), params: params)
            
            
           
            
        }
 
        
        cartVM?.postNewDraftOrder(target: .draftOrder(id: "6839029793046"), params: params)
        
        
    }
    
    @IBAction func addtofavourite(_ sender: Any) {
        if flag == false {
            favbtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            flag = true
        }
        else
        {
            favbtn.setImage(UIImage(systemName: "heart"), for: .normal)
            flag = false
        }
    }
   func productfilter(sender:UIButton)
    {
        switch sender{
            
        case pulldowncolor:
            let c = {(action : UIAction) in}
            let colors = detailedProduct?.options?[1].values
            var colorsAction : [UIAction] = []
            for color in colors! {
                colorsAction.append(UIAction(title: color, handler: c))
            }
            pulldowncolor.menu = UIMenu( title : "" ,children: colorsAction)
            self.pulldowncolor.showsMenuAsPrimaryAction = true
       
        case pulldownsize:
            let c = {(action : UIAction) in
            }
            let sizes = detailedProduct?.options?[0].values
             var sizesAction : [UIAction] = []
             for size in sizes! {
                 sizesAction.append(UIAction(title: size, handler: c))
             }
            pulldownsize.menu = UIMenu( title : "" ,children: sizesAction)
            self.pulldownsize.showsMenuAsPrimaryAction = true
            
        default:
            print("no")
        }
    }
    
}

// MARK: - Collection View Extension

extension ProductDetailsVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailedProduct?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerbrandcell", for: indexPath) as! BrandCVCell
        
        cell.offerbrandimg.kf.setImage(with: URL(string: detailedProduct?.images?[indexPath.row].src ?? ""))
        return cell
    }
}

extension ProductDetailsVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ItemCV.layer.frame.size.width - 5, height: ItemCV.layer.frame.size.height - 5)
    }
}

// MARK: - Table View Extension

extension ProductDetailsVC : UITableViewDelegate
{
    
}

extension ProductDetailsVC : UITableViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTVCell", for: indexPath) as! ReviewTVCell
       
        
        return cell
    }
}
