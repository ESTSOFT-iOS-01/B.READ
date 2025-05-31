//
//  AlanSummaryView.swift
//  B.READ
//
//  Created by 김도연 on 6/1/25.
//

import SwiftUI

struct AlanSummaryView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  
  let htmlText1 = "\n<!DOCTYPE html>\n<html lang=\"ko\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>HTML 태그 예시</title>\n</head>\n<body>\n    <header>\n        <h1>HTML 태그를 사용한 예시 문서</h1>\n    </header>\n    <nav>\n        <ul>\n            <li><a href=\"#section1\">섹션 1</a></li>\n            <li><a href=\"#section2\">섹션 2</a></li>\n            <li><a href=\"#section3\">섹션 3</a></li>\n        </ul>\n    </nav>\n    <main>\n        <section id=\"section1\">\n            <h2>섹션 1: 소개</h2>\n            <p>HTML은 <strong>HyperText Markup Language</strong>의 약자로, 웹 페이지를 만들기 위해 사용되는 마크업 언어입니다. HTML은 웹 페이지의 구조를 정의하고, 다양한 요소를 포함할 수 있습니다.</p>\n        </section>\n        <section id=\"section2\">\n            <h2>섹션 2: 주요 태그</h2>\n            <p>HTML에는 다양한 태그가 있으며, 그 중 일부는 다음과 같습니다:</p>\n            <ul>\n                <li><code>&lt;h1&gt; - &lt;h6&gt;</code>: 제목을 정의하는 태그</li>\n                <li><code>&lt;p&gt;</code>: 단락을 정의하는 태그</li>\n                <li><code>&lt;a&gt;</code>: 하이퍼링크를 정의하는 태그</li>\n                <li><code>&lt;ul&gt;</code> 및 <code>&lt;li&gt;</code>: 목록을 정의하는 태그</li>\n                <li><code>&lt;div&gt;</code>: 구역을 정의하는 태그</li>\n            </ul>\n        </section>\n        <section id=\"section3\">\n            <h2>섹션 3: 결론</h2>\n            <p>HTML은 웹 페이지의 기본 구조를 정의하는 데 필수적인 언어입니다. 다양한 태그를 사용하여 콘텐츠를 구조화하고, 스타일을 지정하며, 상호작용을 추가할 수 있습니다.</p>\n        </section>\n    </main>\n    <footer>\n        <p>&copy; 2025 HTML 예제 문서</p>\n    </footer>\n</body>\n</html>\n"
  
  let htmlText = """
  <h1>🎉 HTML이 이렇게 멋질 수 있다니!</h1>
  <p>안녕하세요 👋 SwiftUI 개발자 여러분!</p>
  <p>여기 이모지와 함께 즐기는 <strong>HTML</strong> 예시를 소개합니다 😎</p>

  <ul>
    <li>🔥 빠른 개발</li>
    <li>🧠 똑똑한 문서 렌더링</li>
    <li>📱 SwiftUI + UIKit 완벽 콜라보</li>
  </ul>

  <p>더 많은 가능성이 기다리고 있어요... 🚀</p>
  """
  
    var body: some View {
      HTMLTextView(html: htmlText + htmlText1 + htmlText1)
        .padding()
    }
}

#Preview {
    AlanSummaryView()
}

struct HTMLTextView: UIViewRepresentable {
  let html: String
  
  func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
    let textView = UITextView()
    textView.isEditable = false
    textView.isScrollEnabled = true
    textView.backgroundColor = .clear
    textView.textContainerInset = .zero
    textView.textContainer.lineFragmentPadding = 0
    
    return textView
  }
  
  func updateUIView(_ uiView: UITextView, context: Context) {
    let data = Data(html.utf8)
    if let attributedString = try? NSAttributedString(
      data: data,
      options: [.documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue],
      documentAttributes: nil
    ) {
      uiView.attributedText = attributedString
    } else {
      uiView.attributedText = NSAttributedString(string: "⚠️ HTML 파싱 실패!")
    }
  }

}
