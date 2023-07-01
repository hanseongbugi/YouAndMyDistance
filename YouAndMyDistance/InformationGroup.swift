//
//  InfomationGroup.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/15.
//
import Foundation

class InformationGroup: NSObject{
    var informations = [Information]()
    var fromDate, toDate: Date?     // queryData 함수에서 주어진다.
    var database: Database!
    var parentNotification: ((Information?, DbAction?) -> Void)?
    
    init(parentNotification: ((Information?, DbAction?) -> Void)? ){
        super.init()
        self.parentNotification = parentNotification
       
        database = DbFirebase(parentNotification: receivingNotification) // 데이터베이스 생성
    }

    func receivingNotification(information: Information?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let information = information{
            switch(action){    // 액션에 따라 적절히 함수를 호출한다
                case .Add: addInformation(information: information)
                case .Delete: removeInformation(removedInfomation: information)
                default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(information, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
}
extension InformationGroup{
    func queryData(date: Date){
        informations.removeAll()    // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지운다
        // date가 속한 1개월 +-알파만큼 가져온다
        fromDate = date.firstOfMonth().firstOfWeek()// 1일이 속한 일요일을 시작시간
        toDate = date.lastOfMonth().lastOfWeek()    // 이달 마지막일이 속한 토요일을 마감시간
        database.queryInformation(fromDate: fromDate!, toDate: toDate!) //date를 통해 DB에서 쿼리
    }
    func saveChange(information: Information, action: DbAction){
        database.saveChange(information: information, action: action) //action에 따라 Database을 변경
    }
}

extension InformationGroup{
    func getInformations(date: Date? = nil) -> [Information] {
        if let date = date{
            var infoForDate: [Information] = []
            let start = date.firstOfDay()    // yyyy:mm:dd 00:00:00
            let end = date.lastOfDay()    // yyyy:mm”dd 23:59:59
            for information in informations{
                //특정 날짜만 가져오고 다른 사람 정보만 가져온다
                if information.date >= start && information.date <= end && information.owner != Owner.getOwner() {
                    infoForDate.append(information)
                }
            }
            return infoForDate
        }
        return informations
    }
    func getMyInformations(date: Date? = nil) -> [Information] {
        if let date = date{
            var planForDate: [Information] = []
            let start = date.firstOfDay()    // yyyy:mm:dd 00:00:00
            let end = date.lastOfDay()    // yyyy:mm”dd 23:59:59
            for information in informations{
                //특정 날짜만 가져오고 내 정보만 가져온다
                if information.date >= start && information.date <= end && information.owner == Owner.getOwner() {
                    planForDate.append(information)
                }
            }
            return planForDate
        }
        return informations
    }
}

extension InformationGroup{
    private func count() -> Int{ return informations.count }
    
    private func find(_ key: String) -> Int?{
        for i in 0..<informations.count{
            if key == informations[i].key{//key값이 같으면
                return i //index 반환
            }
        }
        return nil //못찾으면 nil
    }
}

extension InformationGroup{
    private func addInformation(information:Information){
        informations.append(information)
        
    }
    private func removeInformation(removedInfomation: Information){
        if let index = find(removedInfomation.key){
            informations.remove(at: index)
        }
    }
}
