## 개요

-	사진만으로 상대방의 위치를 유추하기 어렵다. 또한 나와 상대방 간의 거리를 알 수 있는 방법은 사진만으로 알아내기 어렵다. 따라서 사진을 통해 나와 상대방의 위치를 알아내어 이를 통해 거리를 구하여 지도에 나타내는 앱을 제작하였다.
-	이 앱을 통해 사용자는 상대방의 위치를 빠르게 파악할 수 있다. 또한 사진을 올리는 행위만으로 설명하기 어려운 나의 위치를 편리하게 알려줄 수 있다. 마지막으로 위치를 설명하는데 소요되는 시간을 절약할 수 있다.

## 구조도

![image](https://github.com/hanseongbugi/YouAndMyDistance/assets/105718365/65fb9392-4b7e-446c-adb3-77d4989c963b)

## 앱 기능

* Information Group View
  * 이 화면에서는 tableView를 통해 다른 사용자가 업로드한 날짜와 사용자 이름, 위도, 경도를 확인할 수 있으며, NavigationItem에 있는 plus 버튼을 통해 내 위도, 경도를 업로드 할 수 있는 화면으로 이동할 수 있다. 또한 Edit 버튼을 눌러 내 게시물 관리 화면으로 이동할 수 있다. 마지막으로 달력을 통해 날짜를 선택하면 해당 날짜에 다른 사용자가 업로드한 정보를 확인할 수 있다.
* My Information View
  * 내가 업로드한 모든 게시물에 대해 tableView를 통해 보여준다. NavigationItem에 있는 버튼인 쓰레기통 버튼을 누르면 tableView는 Editing 상태가 true로 변하고 쓰레기통 버튼은 취소 버튼으로 바뀌게 된다. 또한 cell에 있는 동그란 마이너스 버튼을 누르게 되면 Delete 버튼이 생성되고 Delete를 클릭하면 삭제 확인 메시지를 출력한다. 또한 삭제를 하면 내가 업로드한 게시물이 사라지게 된다. 마지막으로 취소 버튼을 누르게 된다면 Editing 상태가 false로 변하게 된다.
* Information Upload View
  * 내가 사진을 올릴 날짜를 DatePickerView를 통해 보여주고, 현재 접속한 계정의 주인을 UILabel을 통해 보여준다. 또한 UIImageView를 터치하면 갤러리로 이동하게 되고 다른 사용자에게 알려주고 싶은 장소의 사진을 선택할 수 있다. 이미지를 선택하면 UILabel에 위도와 경도가 출력된다. 마지막으로 Back 버튼을 누르게 되면 위도와 경도 데이터가 있을 경우 데이터베이스에 게시물이 저장되며 다른 사용자에게 내가 업로드한 게시물이 보여지게 된다.
* Choice View
  * Information Group View에서 tableView에 존재하는 다른 사용자의 게시물 cell을 터치한다면 이동할 수 있는 View이다. UILabel을 통해 View에 대한 간략한 설명을 보여준다. UIImageView를 클릭하면 갤러리로 이동하게 된다. 이때 이미지를 선택하면 위도와 경도가 UILabel을 통해 보여지게 된다. 너와 나의 거리는 이라는 버튼을 누르게 되면 이미지를 통해 위도와 경도를 얻어 왔을 경우 지도 화면으로 이동하게 되고, Back 버튼을 누르면 게시물 그룹 화면으로 돌아가게 된다.
* Map View
  * Map View에서는 Information Group View에서 선택한 다른 사용자의 위도, 경도와 Choice View에서 선택한 위도, 경도를 통해 거리를 계산하여 어노테이션으로 거리를 지도에 그려주는 화면이다. 다른 사용자의 위도와 경도를 통해 Other 어노테이션을 지도에 그리고, 나의 위도와 경도를 통해 Me 어노테이션을 지도에 그려준다. 마지막으로 Back 버튼을 누르면 다시 내 위치를 선택할 수 있다.

## 실행 화면

　　　　　초기화면　　　　　　　　　　　　　데이터 삽입<br>
<img src="https://github.com/hanseongbugi/YouAndMyDistance/assets/105718365/0530d125-f5fd-4bd8-b9b1-df8af94992e7" width="200" height="200"/>　　　<img src="https://github.com/hanseongbugi/YouAndMyDistance/assets/105718365/278391ac-04d3-4641-a7b8-9f97c71126b3" width="200" height="200"/><br><br>                            
　　　　　삭제준비　　　　　　　　　　　　　　삭제완료<br>
<img src="https://github.com/hanseongbugi/YouAndMyDistance/assets/105718365/db699cf2-d465-4496-a052-1edcc5ad2642" width="200" height="200"/>　　　<img src="https://github.com/hanseongbugi/YouAndMyDistance/assets/105718365/0434e103-7c1e-40ab-9d24-f12f3b2b71e2" width="200" height="200"/><br><br>          
　　　　거리 계산 준비　　　　　　　　　　　　거리계산<br>
　　　　<img src="https://github.com/hanseongbugi/YouAndMyDistance/assets/105718365/be3d4355-2912-40d0-a4ec-aa6457a45418" width="100" height="200"/>　　　　　　　　　　<img src="https://github.com/hanseongbugi/YouAndMyDistance/assets/105718365/eac14cd3-7534-4054-937c-e726bbb2c520" width="100" height="200"/>
