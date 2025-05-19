# iTunes App

**iTunes App**은 iTunes 콘텐츠를 기반으로 사용자에게 음악, 영화, 팟캐스트를 탐색할 수 있는 iOS 애플리케이션입니다.
RxSwift 기반의 반응형 아키텍처와 Hero 애니메이션, Skeleton UI, debounce 기반 검색 최적화를 통해 부드러운 사용자 경험을 제공합니다.

<br>

## 주요 기능
#### 계절별 음악 홈 화면 구성
- 홈 화면에서는 **봄, 여름, 가을, 겨울**에 맞는 음악을 4개의 섹션으로 나누어 **컬렉션 뷰**로 제공합니다.

#### 검색 기능 (SearchController + debounce)
- 네비게이션 바 상단에 `UISearchController`를 배치하여 실시간 검색이 가능하며, 사용자가 입력을 멈춘 후 **1초가 지난 뒤에만** API 요청을 보내어 네트워크 부하를 줄입니다.
- 검색 결과는 별도의 화면에서 표시되며, **영화(Movie)** 및 **팟캐스트(Podcast)** 만 검색됩니다.

#### Skeleton UI 로딩 애니메이션
- `SkeletonView`를 통해 로딩 중인 셀에 애니메이션을 적용하여 콘텐츠 준비 상태를 시각적으로 표현합니다.

#### 상세 정보 화면 및 Hero 애니메이션
- 콘텐츠 선택 시 Hero 라이브러리를 통해 부드러운 **Match 애니메이션**과 함께 상세 정보를 제공합니다.

#### 아래로 당겨서 닫기 제스처
- 상세 화면에서 스크롤을 아래로 내리면 화면이 자연스럽게 dismiss됩니다.

#### 공유 기능
- 상세 화면에서 현재 보고 있는 콘텐츠를 외부로 공유할 수 있습니다.

<br>

## 기술 스택
#### UI 프레임워크: UIKit
#### 레이아웃: SnapKit
#### 비동기 처리
- `Swift Concurrency`: `async/await` 기반의 비동기 네트워킹 (iTunes API 호출 등)
- `RxSwift`, `RxCocoa`, `RxRelay`: UI 바인딩 및 이벤트 스트림 처리
#### 이미지 로딩: Kingfisher
#### 로딩 애니메이션: SkeletonView
#### 화면 전환 애니메이션: Hero
#### 설계 패턴: MVVM + Clean Architecture
#### API: iTunes Search API

<br>

## 스크린샷

| 홈 화면 (계절별 음악)                                                                  | 검색 결과 (debounce 적용)                                                                | 상세 화면 (Hero 애니메이션)                                                                 |
| ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/2da5883b-b979-417f-87e9-9ce80ed20794" width="250" /> | <img src="https://github.com/user-attachments/assets/729a044c-8e11-454d-8f6f-0028be78c98a" width="250" /> | <img src="https://github.com/user-attachments/assets/83f3948e-7309-4720-99f5-fa7d9598bda0" width="250" /> |

<br>

## 프로젝트 구조

```
iTunesApp/
├── App
│   ├── AppDelegate.swift
│   ├── DIContainer.swift
│   └── SceneDelegate.swift
│
├── Data
│   ├── DTO
│   ├── RepositoryImpl
│   └── iTunesApiService.swift
│
├── Domain
│   ├── Entity
│   ├── Model
│   ├── Repository
│   └── UseCase
│
├── Presentation
│   ├── Home
│   ├── Search
│   └── Detail
│
├── Resources
│   ├── Assets.xcassets
│   └── Info.plist
│
└── Utils
    ├── Extensions
    └── Constants.swift
```
