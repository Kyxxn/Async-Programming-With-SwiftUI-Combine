## 상태 관리를 위한 StateObject & ObservedObject & EnvironmentObject

### StateObject
> iOS 14.0 +, SwiftUICore 프레임워크
>
> `struct StateObject<ObjectType> where ObjectType : ObservableObject`

#### 개념

- `StateObject`는 객체가 생성될 때 SwiftUI가 객체를 소유하고 관리함
- 딱 한 번만 객체를 생성하게 보장하는 것이 핵심

#### 사용시기
- ObservableObject의 변경 사항이나 갱신을 모니터링할 필요가 있을 때 사용
- 뷰 자체에서 모니터링을 원하는 인스턴스를 만들었을 때 사용

##

### ObservedObject
> iOS 13.0 +, Combine 프레임워크
>
> `struct ObservedObject<ObjectType> where ObjectType : ObservableObject`

#### 개념

- 위와 동일하게 ObservableObject를 참조하는 프로퍼티 래퍼
- 그러나 차이 점으로, 뷰가 재생성될 때마다 다시 생성되는 특징이 있음
- 즉, `ObservedObject`는 객체가 뷰 외부에서 생성되고 관리될 때 사용하면 됨

#### 사용시기

- ObservedObject에서의 변경이나 갱신이 발생하는 것을 모니터링해야 할 때 사용
- 뷰에 포함된 객체가 뷰 자체가 아닌, 외부에서 생성되고 관리되는 경우에 사용

##

### EnvironmentObject
> iOS 13.0 +, SwiftUICore 프레임워크
>
> `struct EnvironmentObject<ObjectType> where ObjectType : ObservableObject`

#### 개념

- 전역으로 공유되는 ObservableObject를 참조하는 프로퍼티 래퍼
- 뷰 계층 구조에서 공유되는 객체를 참조할 때 사용
- *주의*: ObservableObject를 환경에 주입했는지 확인할 방법이 없기에 뷰가 해당 객체를 참조할 때, 해당 객체가 주입되지 않았다면 런타임 오류가 발생함

#### 사용시기

- ObservedObject가 변경되거나 갱신할 필요가 있을 때 사용
- 실제로 ObservedObject가 필요한 뷰를 만나기 전까지는 해당 객체가 불필요한 여러 뷰를 거쳐야 할 때 사용
- 상태를 루트 View에서 설정하고 앱 전체에서 접근하고 싶을 때
