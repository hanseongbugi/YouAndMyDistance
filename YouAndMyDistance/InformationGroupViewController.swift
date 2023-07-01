//
//  InfomationGroupViewController.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/15.
//
import UIKit
import FSCalendar

class InformationGroupViewController: UIViewController {
    @IBOutlet weak var fsCalendar: FSCalendar!
    
    @IBOutlet weak var informationGroupTableView: UITableView!
    var informationGroup: InformationGroup!
    var selectedDate: Date? = Date()     

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Owner.loadOwner(sender: self)
        informationGroupTableView.dataSource = self        // 테이블뷰의 데이터 소스 등록
        fsCalendar.dataSource = self                // 켈린더의 데이터소스로 등록
        fsCalendar.delegate = self                  // 켈린더의 딜리게이트로 등록
        // 월~일 글자 폰트 및 사이즈 설정
        fsCalendar.appearance.weekdayFont = UIFont(name: "HSYuji-Regular", size: 12)
        // 숫자들 글자 폰트 및 사이즈 설정
        fsCalendar.appearance.titleFont = UIFont(name:"HSYuji-Regular", size: 14)
        // Header dateFormat, 년도, 월 폰트(사이즈), 가운데 정렬 설정
        fsCalendar.appearance.headerDateFormat = "YYYY년 MM월"
        fsCalendar.appearance.headerTitleFont = UIFont(name:"HSYuji-Regular", size: 16)
        fsCalendar.appearance.headerTitleAlignment = .center
        //informationGroup에서 전달받을 함수를 인자로 InformationGroup 객체 생성
        informationGroup = InformationGroup(parentNotification: receivingNotification)
        informationGroup.queryData(date: Date())       // 이달의 데이터를 가져온다.
        //navigationItem의 title 설정 및 폰트(사이즈) 설정
        self.navigationController?.navigationBar.topItem?.title = "너와 나의 거리는?"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HSYuji-Regular", size: 24)!, .foregroundColor : UIColor(red: 245/255, green: 117/255, blue: 227/255, alpha: 1)]
    }
    override func viewDidAppear(_ animated: Bool) {
        Owner.loadOwner(sender: self) // Owner에서 owner를 load한다.
    }
    func receivingNotification(infomation: Information?, action: DbAction?){
        self.informationGroupTableView.reloadData() //informationGroupTableView의 data를 갱신
        fsCalendar.reloadData() //켈린더의 data를 갱신
    }
}
extension InformationGroupViewController{
    @IBAction func addingInfomation(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddInfomation", sender: self)
    }
    @IBAction func editingInfomations(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showMyInfomation", sender: self)
    }
}

extension InformationGroupViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let informationGroup = informationGroup{
            //캘린더의 date를 통해 infomations의 개수를 얻고
            //이를 tableView의 row 개수로 반환
            return informationGroup.getInformations(date:selectedDate).count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell")! //tableView cell을 identifier를 통해 가져옴
        let information = informationGroup.getInformations(date:selectedDate)[indexPath.row] //캘린더 date를 통해 informations 배열을 반환 받고 row에 따라 infomation을 가져온다.
        
        //가져온 infomation을 통해 cell의 label의 text를 설정
        (cell.contentView.subviews[0] as! UILabel).text = information.date.toStringDateTime()
        (cell.contentView.subviews[1] as! UILabel).text = information.owner
        if let location = information.location{
            (cell.contentView.subviews[2] as! UILabel).text = "Latitude : \(String(format: "%.4f",location.latitude))"
            (cell.contentView.subviews[3] as! UILabel).text = "Longitude : \(String(format: "%.4f",location.longitude))"
        }
        return cell
    }
}


extension InformationGroupViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChoice"{
            //choiceViewController를 segue를 통해 가져온다.
            let choiceViewController = segue.destination as! ChoiceViewController
            if let row = informationGroupTableView.indexPathForSelectedRow?.row{
                //선택한 row 번호를 통해 choiceViewController에 information을 전달한다
                choiceViewController.configure(withData: informationGroup.getInformations()[row].location!)
            }
            //informationGroupTableView에서 선택한 row의 포커스를 제거
            informationGroupTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
        }
        if segue.identifier == "AddInfomation"{
            //InformationUploadViewController를 segue를 통해 가져온다.
            let informationUploadViewController = segue.destination as! InformationUploadViewController
            informationUploadViewController.saveChangeDelegate = saveChange //saveChangeDelegate를 등록
            //information을 생성하고 전달
            informationUploadViewController.information = Information(date:selectedDate, withData: false)
        }
    }

    func saveChange(information: Information){
        if informationGroupTableView.indexPathForSelectedRow != nil{
            informationGroup.saveChange(information: information, action: .Modify)
        }else{
            informationGroup.saveChange(information: information, action: .Add) //add Action
        }
    }
}

extension InformationGroupViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date.setCurrentTime() //선택한 date를 통해 현재 시간을 가져와 selectedDate에 저장
        informationGroup.queryData(date: date) //선택한 date를 통해 informationGroup에서 queryData 호출
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        selectedDate = calendar.currentPage // 현재 페이지가 변경되면 현재 페이지를 seletedDate에 저장
        informationGroup.queryData(date: calendar.currentPage) //이를 통해 queryData 호출
    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let informations = informationGroup.getInformations(date: date) // date를 통해 infomations를 반환 받음
        var count = 0
        for info in informations{
            if info.owner != Owner.getOwner(){ //다른 사용자의 info이면
                count += 1 // count 증가
            }
        }
        if count > 0 {
            return "[\(count)]"
        }
        return nil
    }
}
