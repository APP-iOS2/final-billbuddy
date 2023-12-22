# BillBuddy
![billbuddy](https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/39554895-74b8-4232-b484-84a9d1ddb102)
<br>
<br>

## 프로젝트 소개
> 깔끔한 정산 시스템과 편리한 채팅 기능을 통해 친구와의 여행을 더 즐겁게 만들어 주는 iOS 앱 입니다.
- 개발 기간
  - 기획 : 2023.9.19 ~ 2023.9.25
  - 개발 : 2023.9.26 ~ 2023.10.24
- 기술 스택
  - Swift 5, iOS 16.0, XCode 15.0
  - 라이브러리 : Firebase, TossPayments, Google AbMob
  - 협업 도구 : Github, Figma, Notion, Discord
  - 다크모드 미지원, 가로모드 미지원 
<br>

## 주요 기능
- **`홈(여행목록)`** 정산 중인 여행과 정산 완료된 여행 목록을 확인하고 새로운 여행을 생성할 수 있습니다.
- **`여행 디테일`** 지출 내역을 추가할 수 있고 인원/일자/전체 정산 내역과 지도를 통한 지출 장소를 확인할 수 있습니다.
- **`채팅`** 여행 참여 멤버들과 채팅할 수 있고 채팅을 통해 주고받은 사진을 한 번에 모아 확인할 수 있습니다.
- **`구독 결제`** 토스 페이먼츠 결제를 통해 광고를 제거해 주는 프리미엄 멤버십을 구독할 수 있습니다.
- **`푸시 알림(초대)`** 푸시 알림을 통해 딥링크를 전송하여 친구를 초대할 수 있고, 지출내역 변동과 새로운 채팅 메시지 알림을 발송합니다.
<br>

## 화면
|`회원가입, 로그인`|`마이페이지`|`광고, 구독 결제`|
|-------|-------|-------|
|<img src="https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/42fca4ca-e6b8-49f2-a7be-af8fd9b046bc" width="190" height="400">|<img src="https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/6562be49-0766-4575-aaf6-18436ff1644a" width="190" height="400">|<img src="https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/ee175aea-313b-4b0f-9768-e4bf3acaaf10" width="190" height="400">|

|`여행 생성, 친구 초대`|`지출 내역 추가`|
|-------|-------|
|<img src="https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/80543822-d73d-40f0-9c76-ceee1f5ed6f0" width="380" height="400">|<img src="https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/8aab0fe4-37cf-4aec-bb05-713b8dccac26" width="380" height="400">|

|`지출 내역 수정, 삭제`|`지출 지도, 결산`|
|-------|-------|
|<img src="https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/a95fa06d-b33e-4da5-ac1c-c85c38355859" width="380" height="400">|<img src="https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/4b83fea1-9a04-480b-af0a-ef708fb1e04f" width="380" height="400">|

|`채팅`|
|-------|
|<img src="https://github.com/APPSCHOOL3-iOS/final-billbuddy/assets/51072429/136fbfcc-a81f-4970-803c-779e984c443b" width="380" height="400">|
<br>

## Architecture
MV
<br>
<br>

## Folder Structure
```
📦BillBuddy
 ┣ 🗂Common
 ┣ 🗂Config
 ┣ 🗂Extension
 ┣ 🗂Model
 ┣ 🗂Resource
 ┃ ┣ 🗂Assets.xcassets
 ┃ ┗ 🗂font
 ┣ 🗂Scene
 ┃ ┣ 🗂Admob
 ┃ ┃ ┗ 🗂View
 ┃ ┣ 🗂App
 ┃ ┣ 🗂Chatting
 ┃ ┃ ┣ 🗂Model
 ┃ ┃ ┣ 🗂Store
 ┃ ┃ ┗ 🗂View
 ┃ ┣ 🗂Content
 ┃ ┣ 🗂DeepLink
 ┃ ┣ 🗂Detail
 ┃ ┃ ┣ 🗂Store
 ┃ ┃ ┗ 🗂View
 ┃ ┣ 🗂Map
 ┃ ┣ 🗂Membership
 ┃ ┃ ┣ 🗂Notification
 ┃ ┃ ┣ 🗂Store
 ┃ ┃ ┗ 🗂View
 ┃ ┣ 🗂MyPage
 ┃ ┃ ┣ 🗂Store
 ┃ ┃ ┗ 🗂View
 ┃ ┣ 🗂Sign
 ┃ ┃ ┣ 🗂Model
 ┃ ┃ ┣ 🗂Store
 ┃ ┃ ┗ 🗂View
 ┃ ┗ 🗂TravelList
 ┃ ┃ ┣ 🗂Model
 ┃ ┃ ┣ 🗂Store
 ┃ ┃ ┗ 🗂View
 ┗ 📜Service
```

## Git Flow
```mermaid
gitGraph
    commit id: "Main"
    branch dev
    checkout dev
    commit
    branch name/feature
    checkout name/feature
    commit id: "${taskA}"
    commit id: "${taskB}"
    checkout dev
    merge name/feature
    commit
    commit
    commit
    checkout main
    merge dev
    commit id: "Deploy"
```

## Team 돈독
| 윤지호 | 김상인 | 김유진 | 노유리 |
|:---:|:---:|:---:|:---:|
| <img src="https://avatars.githubusercontent.com/u/109410688?v=4" width="100%"/> | <img src="https://avatars.githubusercontent.com/u/73647861?v=4" width="100%"/> | <img src="https://avatars.githubusercontent.com/u/55521930?v=4" width="100%"/> | <img src="https://avatars.githubusercontent.com/u/51072429?v=4" width="100%"/> |
| [@yoonjiho37](https://github.com/yoonjiho37) | [@sikim4991](https://github.com/sikim4991) | [@usingkim](https://github.com/usingkim) | [@yforyuri](https://github.com/yforyuri) |
| PM, 딥링크, 결산 | 광고, 구독결제 | 여행 디테일 | 채팅 |

| 박지현 | 이승준 | 한아리 | 황지연 |
|:---:|:---:|:---:|:---:|
| <img src="https://avatars.githubusercontent.com/u/134076497?v=4" width="100%"/> | <img src="https://avatars.githubusercontent.com/u/73987824?v=4" width="100%"/> | <img src="https://avatars.githubusercontent.com/u/133969263?v=4" width="100%"/> | <img src="https://avatars.githubusercontent.com/u/46298003?v=4" width="100%"/> |
| [@wowhyunnie](https://github.com/wowhyunnie) | [@seungzunlee](https://github.com/seungzunlee) | [@ariirang](https://github.com/ariirang) | [@growlamb](https://github.com/growlamb) |
| 회원가입, 로그인, 마이페이지 | 지도 | 여행 리스트 | 푸시 알림 |


