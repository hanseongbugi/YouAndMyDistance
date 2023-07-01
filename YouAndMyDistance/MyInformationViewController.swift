//
//  MyInfomationViewController.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/18.
//

import UIKit

class MyInformationViewController: UIViewController {
    @IBOutlet weak var myInformationGroupTableView: UITableView!
    var informationGroup: InformationGroup!
    var selectedDate: Date? = Date()  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Owner.loadOwner(sender: self)
        myInformationGroupTableView.dataSource = self        // 테이블뷰의 데이터 소스 등록
        myInformationGroupTableView.delegate = self         //테이블뷰의 딜리게이트 등록
        //informationGroup에서 전달받을 함수를 인자로 InformationGroup 객체 생성
        informationGroup = InformationGroup(parentNotification: receivingNotification)
        informationGroup.queryData(date: Date()) // 이달의 데이터를 가져온다.
    }

    override func viewDidAppear(_ animated: Bool) {
        Owner.loadOwner(sender: self)
    }
    func receivingNotification(infomation: Information?, action: DbAction?){
        self.myInformationGroupTableView.reloadData()
    }
    @IBAction func informationEdit(_ sender: UIBarButtonItem) {
        if myInformationGroupTableView.isEditing{
            myInformationGroupTableView.isEditing = false
            sender.title = "Edit"
            sender.image = UIImage(systemName: "trash.circle")
        }
        else{
            myInformationGroupTableView.isEditing = true
            sender.title = "Done"
            sender.image = UIImage(systemName: "xmark.circle")
        }

    }
}

extension MyInformationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let informationGroup = informationGroup{
            return informationGroup.getMyInformations(date:selectedDate).count
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "") // TableViewCell을 생성한다
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyInfoTableViewCell")!
        let information = informationGroup.getMyInformations(date:selectedDate)[indexPath.row]
        cell.selectionStyle = .none
        (cell.contentView.subviews[0] as! UILabel).text = information.date.toStringDateTime()
        (cell.contentView.subviews[1] as! UILabel).text = information.owner
        if let location = information.location{
            ((cell.contentView.subviews[2] as! UIStackView).subviews[0] as! UILabel).text = "Latitude : \(String(format: "%.4f",location.latitude))"
            ((cell.contentView.subviews[2] as! UIStackView).subviews[1] as! UILabel).text = "Longitude : \(String(format: "%.4f",location.longitude))"
        }
        return cell
    }
}

extension MyInformationViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let infomation = self.informationGroup.getMyInformations()[indexPath.row]
            let title = "Delete latitude : \(String(format: "%.4f",infomation.location!.latitude)) longitude : \(String(format:"%.4f",infomation.location!.longitude))"
   
            let message = "Are you sure you want to delete this item?"

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action:UIAlertAction) -> Void in
                
                // 선택된 row의 information을 가져온다
                let information = self.informationGroup.getMyInformations()[indexPath.row]
                // 단순히 데이터베이스에 지우기만 하면된다. 그러면 꺼꾸로 데이터베이스에서 지워졌음을 알려준다
                self.informationGroup.saveChange(information: information, action: .Delete)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil) //여기서 waiting 하지 않는다
        }
    }
}
