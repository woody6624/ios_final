## HopeMessage

## 힘든 세상 서로 서로 응원하는 어플리케이션

1991143 김우현

# 백엔드 레포지터리: https://github.com/woody6624/ios_final_backend

# 벡앤드 API 명세서
![API-명세서](https://github.com/woody6624/ios_final/assets/103871252/73f44241-d56b-4f79-aa14-b7464af90b0b)





# 1.프로젝트 수행 목적


## 1-1 .프로젝트 정의

- 프론트엔드(Swift)와 백엔드(Springboot)를 활용한 서울시 응원 어플리케이션


## 1-2.프로젝트 배경

- 서로서로 열심히 또 힘들게 현실을 살아가는 사람들끼리 서로서로 응원해주었으면 하는 어플리케이션을 고민하다 서로 응원메시지를 주면 어떨까?라는 생각에 만들게 되었습니다.
- 응원메시지 뿐만아니라 명화와 서울시 각 구마다의 관광 명소를 보며 힐링을 할 수있는 어플리 케이션을 만들고 싶어 해당 기능을 추가하여 구성했습니다.



## 1-3.프로젝트 목표

- 응원 메시지 등록 및 목록 보기
    - RDS와 연동된 MySQL에 지속적으로 저장시키고 메시지를 등록하거나 따봉 카운트를 증가시키면 데이터베이스에서 지속적으로 해당 내용을 가져와서 보여주기
- 명화 보여주기
    - 명화를 통해 심리적 안정을 제공하는것이 주 목표 . AWS S3버킷에 이미지를 저장시켜두고 해당 이미지와 데이터베이스에 저장된 명화의 정보를 프론트엔드 단으로 넘겨주기
- 각 구마다의 명소 보여주기
    - 서울시 각 구마다 명소를 DB에 저장하여(이미지는 위 명화와 같은 방식)  보여주기
    - 폴리곤을 직접 설정하여 각각의 구를 시각적으로 분리되게 보여주고 마커를 클릭하는 방식으로 명소 보여주기



# 2.프로젝트 개요



## 2-1.프로젝트 설명

- 회원가입 시에 자신이 속한 구(예를 들어 성북구)를 등록하여 응원 메시지가 자신이 속한 구 기준으로 나오게 합니다.
- 기본적인 로그인 로그아웃 기능에서 유저 세션을 싱글톤 객체로 하나 만들어서 로그인 시에 유저 세션에 정보를 넣어두고 로그아웃 시에는 유저 세션 정보를 널로 하는 방식으로 구현하였습니다.
- 명화와 관광 명소의 이미지는 S3 BUCKET에 저장해두고 객체 URL을 RDS와 연관된 MySQL에 저장해서 데이터베이스에서 정보를 받아오는 방식으로 명화와 관광 명소를 보여주도록 구현하였습니다.
- MkMapView를 사용하여서 서울시에 해당하는 지도를 표시하며 폴리곤을 사용하여서 각 구마다 경계를 명확하게 표현하였습니다.
    - 이렇게 명확하게 표현한 구의 중앙에 마커를 달아서 해당 마커를 클릭 시 해당 구의 관광 명소에 대한 정보가 나타나도록 구현하였습니다.
    - 관광 명소에는 좋아요 버튼이 있으며 좋아요 버튼을 눌러서 좋아요 count를 증가시킬 수 있습니다.다른 사람들은 이를 보고 좋아요가 얼만큼 있는지 인식이 가능합니다.
- 응원메시지들의 리스트들은 테이블 뷰 방식으로 구현하였고 테이블 뷰의 각각의 셀이 응원 메시지 해당하는 정보입니다.각각의 셀을 클릭시 따봉 카운트가 증가하며 지속적으로 테이블 뷰 안에서 따봉 카운트를 기준으로 내림차순으로 정렬되게 구현하였습니다.



## **2.2 프로젝트 구조**

![구조도](https://github.com/woody6624/ios_final/assets/103871252/15ee1a34-bf98-46de-968f-dd691180cbb9)





## 2-3.결과물

![로그인 회원가입](https://github.com/woody6624/ios_final/assets/103871252/0e86b483-b996-4288-a8a0-6755f691bb49)
<p></p>

![홈](https://github.com/woody6624/ios_final/assets/103871252/962eb421-ab01-47d9-b4ea-640429f71ec3)
<p></p>

![명화와 여행지](https://github.com/woody6624/ios_final/assets/103871252/36efcab2-7bcd-4280-be3b-55fb458a208a)

<p></p>





## 2-4.기대 효과

힘든 하루를 보내고 와서 다른 사람들이 써놓은 응원 메시지를 보고 기운을 얻으며 명화나 서울시 각 구들의 관광 명소들에 대한 정보를 보며 힐링을 받을 수 있습니다.





## 2-5.사용 기술 및 스택

## 개발 환경
  - ![Windows](https://img.shields.io/badge/OS-Windows-blue)
  - ![Mac OS](https://img.shields.io/badge/OS-Mac%20OS-brightgreen)

## 개발 도구
  - ![XCODE](https://img.shields.io/badge/IDE-XCODE-blue)
  - ![IntelliJ IDEA](https://img.shields.io/badge/IDE-IntelliJ%20IDEA-brightgreen)

## 프레임워크
  - ![Spring Boot](https://img.shields.io/badge/Framework-Spring%20Boot-brightgreen)

## 개발 언어
  - ![Java](https://img.shields.io/badge/Language-Java-orange)
  - ![Swift](https://img.shields.io/badge/Language-Swift-orange)

## 서버
  - ![AWS EC2](https://img.shields.io/badge/Server-AWS%20EC2-important)

## 이미지
  - ![AWS S3](https://img.shields.io/badge/Storage-AWS%20S3-informational)

## 데이터베이스
  - ![AWS RDS](https://img.shields.io/badge/Database-AWS%20RDS-orange)
  - ![MySQL](https://img.shields.io/badge/Database-MySQL-blue)

## CI/CD
  - ![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-orange)

## 2-6.발표 영상

https://www.youtube.com/watch?v=QwVriOyZSfE
