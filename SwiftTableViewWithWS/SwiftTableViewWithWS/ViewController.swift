//
//  ViewController.swift
//  SwiftTableViewWithWS
//
//  Created by dharmesh  on 1/3/17.
//

import UIKit
import SDWebImage
import Social

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    
    var arrData : NSArray = []
    var arrFG : NSMutableArray = NSMutableArray ()
    var selectedCell:NSMutableArray = NSMutableArray ()
    var dataDict : [String:AnyObject] = [:]
    var dictTableData : [String:AnyObject] = [:]
    var deletePlanetIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = nil
        self.tblView.dataSource = nil
        self.tblView.estimatedRowHeight = 2.0
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.tableFooterView = UIView()
        self.webServiceCall()
    }
    override func viewWillAppear(_ animated: Bool) {
           self.tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DataTableViewCell = tblView?.dequeueReusableCell(withIdentifier: "Cell") as! DataTableViewCell!
        cell.selectionStyle = .none
        let row = indexPath.row
        dictTableData = (self.arrData[row] as! NSDictionary) as! [String : AnyObject]
        cell.lblData.text = dictTableData["message"] as? String
        cell.lblMainData.text = dictTableData["username"] as? String
        let url = NSURL(string: dictTableData["profile_photo"] as! String )
        cell.activityIndicatoor.startAnimating()
        cell.ImgView.sd_setImage(with: url as URL!, placeholderImage: #imageLiteral(resourceName: "placeholder.png"), options:[], completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?)in
            cell.activityIndicatoor.stopAnimating()
        })
        cell.isExpanded = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        guard let cell = tblView.cellForRow(at: indexPath) as? DataTableViewCell
            else { return }
        if ((self.arrFG[indexPath.row]) as! Int) == 0
        {
            let indexOfA = self.arrFG.index(of: 1)
            if (indexOfA < self.arrFG.count)
            {
                let cell1 = self.tblView.cellForRow(at: IndexPath(item: indexOfA, section: 0) ) as? DataTableViewCell
                self.tblView.beginUpdates()
                cell1?.isExpanded = false
                self.tblView.scrollToRow(at:IndexPath(item: indexOfA, section: 0), at: UITableViewScrollPosition.top, animated: true)
                self.arrFG.replaceObject(at: indexOfA, with: 0)
                self.tblView.endUpdates()
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedCell.add(arrData[indexPath.row])
            print(selectedCell)
            self.tblView.beginUpdates()
            cell.isExpanded = !cell.isExpanded
            self.arrFG.replaceObject(at: indexPath.row, with: 1)
            self.tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
            self.tblView.endUpdates()
        }
        else
        {
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
            selectedCell.remove(arrData[indexPath.row])
            self.arrFG.replaceObject(at: indexPath.row, with: 0)
            UIView.animate(withDuration: 0.3, animations: {
                self.tblView.beginUpdates()
                cell.isExpanded = false
                self.tblView.endUpdates()
            })
        }
    }
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    //        guard let cell = tblView.cellForRow(at: indexPath) as? DataTableViewCell
    //            else { return }
    //        UIView.animate(withDuration: 0.3, animations: {
    //            self.tblView.beginUpdates()
    //            cell.isExpanded = false
    //            self.tblView.endUpdates()
    //        })
    //        self.deletePlanetIndexPath=nil
    //    }
    
    @IBAction func NavigateDetails(_ sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        secondViewController.SelectedData = selectedCell
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete {
            var arry: Array = arrData as Array
            arry.remove(at: indexPath.row)
            arrData = arry as NSArray
            
            self.tblView.reloadData()
        }
    }
    
    func webServiceCall()
    {
        let strKey = "B9C010d9Kg7oFihEF3vV383uD39ugjair"
        let strUserId = "296"
        let postString = "key=\(strKey)&profile_id=\(strUserId)"
        let paramData = postString.data(using: .utf8)
        post(apiUrl: "http://216.55.169.45/~apiphotobug/v1/my-profile-feed", requestPARAMS: paramData!) { (success, responseData) in
            DispatchQueue.main.async
                {
                    if success
                    {
                        let errorMessage = (responseData?["code"] as! NSString).doubleValue
                        if(errorMessage == 100)
                        {
                            print("response data : \(responseData)")
                            self.dataDict = responseData!["data"]!! as!  [String : AnyObject]
                            self.arrData = (self.dataDict["feed_data"] as AnyObject? as? NSArray)!
                            // self.arrData = self.dataDict["feed_data"] as AnyObject as! Array
                            print(self.arrData)
                            for _ in 0..<self.arrData.count {
                                self.arrFG.add(0)
                            }
                            
                            self.tblView?.dataSource = self
                            self.tblView?.delegate = self
                            self.tblView.reloadData()
                        }
                        else
                        {
                        }
                    }
                    else
                    {
                    }
            }
        }
    }
    func post(apiUrl : String, requestPARAMS: Data, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        requestMethod(apiUrl: apiUrl, params: requestPARAMS as Data, method: "POST", completion: completion)
    }
    func requestMethod(apiUrl : String, params: Data, method: NSString, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = method as String
        //request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = params
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with : request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    completion(true, convertedJsonIntoDict)
                }
                else{
                    completion(false, nil)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(false, nil)
            }
        })
        task.resume()
    }
}
//        let request: NSURLRequest = NSURLRequest(url:url as! URL)
//        let mainQueue = OperationQueue.main
//        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
//            if error == nil {
//                // Convert the downloaded data in to a UIImage object
//                let image = UIImage(data: data!)
//                // Store the image in to our cache
//               // self.imageCache[urlString] = image
//                // Update the cell
//                DispatchQueue.main.async {
//                    cell.ImgView.image = image
//                    }
//                }
//            })

