//
//  Database.swift
//  BHS-termProject
//
//  Created by 배한성 on 2023/06/15.
//

import Foundation
// Database.swift
enum DbAction{
    case Add, Delete, Modify // 데이터베이스 변경의 유형
}
protocol Database{
    // 생성자, 데이터베이스에 변경이 생기면 parentNotification를 호출하여 부모에게 알림
    init(parentNotification: ((Information?, DbAction?) -> Void)? )

    // fromDate ~ toDate 사이의 Information을 읽어 parentNotification를 호출하여 부모에게 알림
    func queryInformation(fromDate: Date, toDate: Date)

    // 데이터베이스에 information을 변경하고 parentNotification를 호출하여 부모에게 알림
    func saveChange(information: Information, action: DbAction)
}
