# 네이밍

## 변수

변수 이름은 `lowerCamelCase`를 사용해주세요.

```swift
var categories: [String]
var person: Person
var isShowing: Bool
```

함수
- 함수 이름에는 `lowerCamelCase`를 사용해주세요.
- 함수는 일반적으로 동사원형으로 시작해주세요.
- Event-Handling 함수의 경우 (조동사 + 동사원형)으로 시작해주세요. 주어는 유추 가능하다면, 생략 가능합니다.
    - `will`은 특정 행위가 일어나기 직전을 의미합니다.
    - `did`는 특정 행위가 일어난 직후를 의미합니다.

```swift
private func didFinishSession() {
    // ...
}

private func willFinishSession() {
    // ...
}

private func didChangeSchedule() {
    // ...
}
```

데이터를 가져오는 함수의 경우, `get` 사용을 지양하고 `request`, `fetch`을 적절하게 사용해주세요.

- `request` : 에러가 발생하거나, 실패할 수 있는 비동기 작업에 사용합니다. 예를 들어, http 통신을 통해 값을 요청하는 경우가 이에 해당합니다.
- `fetch` : 요청이 실패하지 않고 결과를 바로 반환할 때 사용합니다. 예를 들어, data를 찾고자 하는 모든 행위를 할 때가 이에 해당합니다.

```swift
func reqeustData(for user: User) -> Data?
func fetchData(for user: User) -> Data
```

## 열거형

- 열거형의 이름은 `UpperCamelCase`를 사용해주세요.
- 열거형의 각 case에는 `lowerCamelCase`를 사용해주세요.

```swift
enum Result {
  case .success
  case .failure
}
```

# 주석


- 프로토콜에는 무조건 Swift 주석 형식을 사용해주세요.

```swift
/// DB내 사용자 이름과 ID로 나이를 조회합니다.
/// - Parameter ID: user ID
/// - Parameter name: user fullname
/// - Returns: user age
func readData(ID: Int, name: String) -> Int {
  var age: Int
  // code to read data...
  return age
}
```

- 연관된 코드가 있다면 `MARK`를 사용하여 코드영역을 구분지어 주세요.

```swift
struct HomeView { ... }

// MARK: - (S)HomeTopView
struct HomeTopView { ... }
```

- 아직 개발이 완료되지 않은 코드가 있다면 `TODO`나 `FIXME`를 사용하여 체크해주세요

```swift
// TODO: 리팩토링
```

# 들여쓰기&띄어쓰기


- 인덴트는 저희 프로젝트에서 스페이스바 2개로 통일하겠습니다.(탭1 = 스페이스바2)

```swift
func sayHiLeeo(isHappy: Bool) {
  if isHappy {
    print("Hi Leeo!")
  }
}
```

- 콜론(`:`)을 사용할 땐 콜론의 오른쪽으로 한 칸의 여백을 생성합니다. (빈 딕셔너리는 제외)

```swift
let monfi: [String: String] = ["승재": "근웅"]
```

- 글자수가 100이 넘어가면, 파라미터 기준으로 줄바꿈을 합니다.

```swift
 func initializeDay(
        locationName: String,
        weather: Int,
        temperature: Double
    ) async throws {
	    // ...code
}

try await initializeDay(
	locationName: "ㅋㅋ",
	weather: "어쩌고",
	temperature: 0.5
)
```

## 후행 클로저


- 인자가 한 개일 경우에만 `$0`을 허용하고,
복잡한 로직 또는 가독성이 떨어질 경우 명시적으로 `element in` 같은 이름을 사용합니다.

```swift
let names = ["A", "B", "C"].map { $0.lowercased() }
```

# SwiftUI

## 네이밍

- struct로 작성된 뷰의 이름은 `UpperCamelCase` 로 작성해주세요.

```swift
struct HomeView { ... }
```

- `@ViewBuilder`로 작성된 컴포넌트의 이름은 `lowerCamelCase` 로 작성해주세요.
(해당 컴포넌트가 어떤것으로 작성되었는지 구분하기 위함)

```swift

@ViewBuilder
private func favoriteButton() -> some View {
  Button {
      isFavorite.toggle()
  } label: {
      ...
  }
}
```

## View 선언

- 뷰 자체는 `struct`로 정의 하되, 필요시에는 컴포넌트 단위로 `@ViewBuilder` 사용을 허용합니다.
- `@ViewBuilder`를 사용하는 조건은 아래와 같습니다.
    - 뷰가 아닌 컴포넌트로 판단 될 시(ex: 버튼, 상단 배너, 도움말…)
    - 한 `struct` 내에서 같은 컴포넌트를 재활용 할 시
    
    ```swift
    struct ItemView: View {
    	var body: some View {
    		VStack {
    			item(name: "아이템1")
    			item(name: "아이템2")
    		}
    	}
    	@ViewBuilder
    	private func item(name: String) -> some View {
    		Text(name)
    	}
    }
    ```
    
    - 하나의 뷰 내에서 중첩된 컨테이너가 3개 초과 시(선택)
    
    ```swift
    struct ItemView: View {
    	var body: some View {
    		VStack { // 중첩 1
    			HStack { // 중첩 2
    				item(name: "아이템1")
    				item(name: "아이템2")
    			}
    		}
    	}
    	
    	@ViewBuilder
    	private func item(name: String) -> some View {
    		Text(name)
    			.background { // 중첩 3
    				ZStack { // 중첩 4
    					Circle()
    						.background(.red)
    				}
    			}
    	}
    }
    ```
    

## 뷰 주석

- 하나의 파일 이내에서 struct를 통한 뷰를 나눌때는 `// MARK: - (S)`를 사용합니다.
- @ViewBuilder를 통해 컴포넌트를 만들때는 `// MARK: (F)`를 사용합니다.

```swift
// MARK: - (S)ItemView
struct ItemView: View {
	var body: some View {
		VStack { // 중첩 1
			HStack { // 중첩 2
				item(name: "아이템1")
				item(name: "아이템2")
			}
		}
	}
	
	// MARK: (F)item
	@ViewBuilder
	private func item(name: String) -> some View {
		Text(name)
			.background { // 중첩 3
				ZStack { // 중첩 4
					Circle()
						.background(.red)
				}
			}
	}
}
```

## 레이아웃

- 하나의 뷰 struct 내에서 레이아웃 컨테이너는 최대 2개까지만 사용하는것을 권장합니다.

```swift
struct ItemView: View {
	var body: some View {
		VStack {
			HStack {
				item(name: "아이템1")
				item(name: "아이템2")
			} // : HStack
		} // : VStack
	}
}
```

- 여백의 경우에는 `Spacer()`의 사용을 최대한 지양하고, `frame()` 사용을 권장합니다.

```swift
// Bad ❌
HStack {
	Spacer()
	Text("맨 오른쪽에 배치해보겠습니다.")
}

// Good ✅
Text("맨 오른쪽에 배치해보겠습니다.")
	.frame(maxWidth: .infinity, alignment: .trailing)
```

- 위 아래 요소간의 배치에 여백을 줘야하는 경우, 특별한 경우가 아니면 아래 요소의 여백으로 배치합니다. 
(`HStack`의 경우에는 오른쪽)

```swift
VStack {
	item(name: "아이템1") 
	// .padding(.bottom, 10) ❌
	item(name: "아이템2")
		.padding(.top, 10)
}
```

- 또한, 일정한 간격으로 배치해야 하는 경우에는 각 컨테이너의 `spacing`을 활용해주세요.

```swift
VStack(spacing: 10) {
	item(name: "아이템1") 
	item(name: "아이템2")
	item(name: "아이템3")
	item(name: "아이템4")
}
```

- 뷰의 전체에 같은 여백을 줘야하는 경우에는 제일 상위 뷰에서 `padding`을 작성해주세요.

```swift
VStack {
	item(name: "아이템1") 
	item(name: "아이템2")
	item(name: "아이템3")
	item(name: "아이템4")
}.padding(.horizontal, 24)
```

- 수평/수직 여백끼리 같은 경우 두개의 `padding` 모디파이어를 사용해주시고 값이 다를때는 `EdgeInsets()` 사용을 허용합니다.

```swift
VStack {
	item(name: "아이템1") 
	item(name: "아이템2")
	item(name: "아이템3")
	item(name: "아이템4")
}
.padding(.horizontal, 24)
.padding(.vertical, 10)
```

## 접근 제어자

- 뷰 초기화 시 매개변수가 필요할때는 생성자를 사용하지 않고 기본 `internal`을 사용합니다.
- 아래 ChildView처럼, 해당 파일 내에서 쓰는 하위 뷰일 경우에는 `struct` 앞에 `private`을 붙여줍니다.

```swift
struct ParentView: View {
	var body: some View {
		VStack {
			ChildView(name: "자식 뷰")
		}
	}
}

private struct ChildView: View {
	
	(Internal)let name: String
	
	var body: some View {
		Text(name)
	}
}
```