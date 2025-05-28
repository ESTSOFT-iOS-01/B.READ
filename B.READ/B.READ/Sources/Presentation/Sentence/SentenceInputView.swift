//
//  SentenceInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct SentenceInputView: View {
    @StateObject var viewModel: SentenceViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isEditorFocused: Bool
    @State private var goNext = false

    private var trimmedContent: String {
        viewModel.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("기록할 문장을 작성해주세요")
                .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.4, letterSpacing: -0.0025)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.content)
                    .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.4, letterSpacing: -0.0025)
                    .padding(12)
                    .frame(height: 130)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.gray0)))
                    .focused($isEditorFocused)
                    .tint(.gray9)

                if viewModel.content.isEmpty && !isEditorFocused {
                    Text("여기를 터치해서 문장을 입력할 수 있어요")
                        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1, letterSpacing: -0.025)
                        .foregroundStyle(.gray2)
                        .padding(12)
                        .allowsHitTesting(false)
                }
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.1)
                        .foregroundStyle(.green6)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("다음") { goNext = true }
                    .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.1)
                    .foregroundStyle(.green6)
                    .disabled(trimmedContent.isEmpty)
                    .opacity(trimmedContent.isEmpty ? 0 : 1)
            }
        }
        .background(Color.backgroundDefault)
        .navigationDestination(isPresented: $goNext) {
          PageInputView(viewModel: viewModel)
        }
    }
}

