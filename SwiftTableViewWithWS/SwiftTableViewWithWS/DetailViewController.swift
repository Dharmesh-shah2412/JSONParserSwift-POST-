//
//  DetailViewController.swift
//  SwiftTableViewWithWS
//
//  Created by dharmesh  on 1/6/17.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblView_Detail: UITableView!
    var SelectedData:NSMutableArray = NSMutableArray ()
    var detailTableData : [String:AnyObject] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tblView_Detail.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.SelectedData.removeAllObjects()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SelectedData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell:DetailViewCell = tblView_Detail?.dequeueReusableCell(withIdentifier: "Cell") as! DetailViewCell!
        print(self.SelectedData)
        detailTableData = (self.SelectedData[indexPath.row] as! NSDictionary) as! [String : AnyObject]
        print(detailTableData)
        cell.LblDetail.text = detailTableData["username"] as? String
        cell.LblDetail.textColor = UIColor.white
        let url = NSURL(string: detailTableData["profile_photo"] as! String )
        cell.DetailProgressView.startAnimating()
        cell.DetailImageView.sd_setImage(with: url as URL!, placeholderImage: #imageLiteral(resourceName: "placeholder.png"), options:[], completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?)in
            cell.DetailProgressView.stopAnimating()
        })
        cell.btnFb.tag = indexPath.row
        cell.btnFb.addTarget(self, action: #selector(postOnFacebook), for: .touchUpInside)
        
        return cell
    }
    func postOnFacebook(sender:UIButton) {
        
        
        let cell = self.tblView_Detail.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as! DetailViewCell!
        let image = cell?.DetailImageView.image
        
        // set up activity view controller
        let imageToShare = [ image!,"Hello apple" ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    
//        
//        let buttonRow = sender.tag
//        print(buttonRow)
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
//            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            fbShare.setInitialText(detailTableData["username"] as? String)
//            let url = URL(string: detailTableData["profile_photo"] as! String)
//            let data = try? Data(contentsOf: url!)
//            fbShare.add(UIImage(data: data!))
//            self.present(fbShare, animated: true, completion: nil)
//            
//        } else {
//            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete {
           // var arry: Array = SelectedData as Array
            SelectedData.removeObject(at: indexPath.row)
            self.tblView_Detail.reloadData()
        }
    }
    
}
