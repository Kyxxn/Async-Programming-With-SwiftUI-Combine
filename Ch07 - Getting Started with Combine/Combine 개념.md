## 반응형 프로그래밍과 Combine

### 반응형 프로그래밍

- 비동기 프로그래밍의 한 형태로, 데이터의 흐름과 변화를 선언적으로 표현하는 방식
- 모든 것이 이벤트이고, 이벤트는 비동기적으로 발생함

##

### Combine
> iOS 13.0 +

- Apple이 제공하는 프레임워크로, 반응형 프로그래밍을 지원
- 시간 경과에 따른 값 변화를 처리할 수 있는 선언형 API
- 사용하기 위해 Publisher, Subscriber, Operator 등의 개념이 필요함

#### Publisher
> `protocol Publisher<Output, Failure>`
>
> 시간이 지남에 따라 값을 전달하는 역할

- 시간이 지남에 따라 값을 방출함
- Subscriber가 구독(subscribe)하면 값을 전달함
- `Just`: 하나의 값만 내보내고 절대 실패하지 않음

<br>

#### Subscriber
> `protocol Subscriber<Input, Failure> : CustomCombineIdentifierConvertible`
> 
> Publisher로부터 값을 받는 역할

- 구독 중인 Upstream Publisher로부터 값을 수신함
- 각 Subscriber는 수신할 값과 오류 유형을 정의함
- `sink`: Publisher로부터 값을 수신하고, 처리하는 클로저를 제공함
- `assign`: Publisher로부터 값을 수신하고, 특정 프로퍼티나 또 다른 Publisher에 할당할 수 있음

<br>

#### Operator
> Publisher와 Subscriber 사이에서 데이터를 변환하거나 필터링하는 역할

- 스트림으로 주고받는 데이터를 추출하거나 필터링 등의 작업을 수행함
- 여러 Operator가 존재하며 이들은 서로 연결해서 사용할 수 있음

<br>

#### Publisher 합치기

- **`.eraseToAnyPublisher()`**
    - 앱에서 여러 이벤트를 관찰해야 할 때가 있음
    - 책의 예제에서 아래 코드의 Publisher 타입은 `Publishers.CompactMap<NotificationCenter.Publisher, OrderStatus>`임
        ``` swift
        let orderStatusPublisher = NotificationCenter
            .default
            .publisher(for: .orderStatusChanged)
            .compactMap { $0.object as? OrderStatus }
        ```
    - 리턴값이 너무 복잡한데, 이 경우 `.eraseToAnyPublisher()`를 사용하여 Publisher를 AnyPublisher로 변환할 수 있음, 그러면 `AnyPublisher<OrderStatus, Never>` 타입이 됨
- 여러 파이프라인을 하나로 결합하기
    - `Zip`, `CombineLatest`, `Merge` 등의 Operator를 사용하여 여러 Publisher의 이벤트를 결합할 수 있음
