//
//  RecordDetailView.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//
import UIKit
import SwiftUI

// MARK: - (S)RecordDetailView
struct RecordDetailView: View {
  @EnvironmentObject private var coordinator: Coordinator<MainRoute, SheetRoute>
  @StateObject private var viewModel: RecordDetailViewModel
  
  @State private var showAddMenu: Bool = false
  @State private var showSortMenu: Bool = false
  @State private var showDeleteAlert: Bool = false
  @State private var needRefresh: Bool = false
  
  private let layoutPadding: CGFloat = 16
  
  // MARK: - Init
  init(viewModel: @autoclosure @escaping () -> RecordDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel())
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .trailing, spacing: layoutPadding) {
        
        RecordBookSection(record: $viewModel.record)
        
        RecordStatsSection(record: $viewModel.record)
          .padding(.top, 8)
        
        TopTabBar(
          tabs: [
            TabItem(title: "메모", image: Image(.menuBread)),
            TabItem(title: "문장", image: Image(.donut))
          ],
          selectedIndex: $viewModel.selectedTab
        )
        .frame(height: 34)
        .padding(.top, 8)
        
        SortMenu(
          isOpened: $showSortMenu,
          selectedOption: $viewModel.selectedSort[viewModel.selectedTab],
          type: viewModel.selectedTab == 0 ? .memo : .quote
        )
        .padding(.trailing, 8)
        .onChange(of: viewModel.selectedSort) { 
          viewModel.send(.selectSort)
        }
        
        RecordNotesSection(viewModel: viewModel)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        
      } // : VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .padding(.horizontal, layoutPadding)
    } // : ScrollView
    .scrollIndicators(.never)
    .background(.backgroundDefault)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        topBarTrailingButton()
      }
    } // : toolBar
    .alert("독서 기록 삭제", isPresented: $showDeleteAlert) {
      Button("삭제", role: .destructive) {
        viewModel.send(.onTapDelete)
        coordinator.pop()
      }
      Button("취소", role: .cancel) { }
    } message: {
      Text("정말로 독서 기록을 삭제하시겠습니까?")
    } // : alert
    .onAppear {
      print("DetailView OnAppear")
      viewModel.send(.onAppear)
      if showAddMenu { UINavigationBar.showOverlay(duration: 0.0) }
      else { UINavigationBar.removeOverlay(duration: 0.0) }
    } // : onAppear
    .onChange(of: coordinator.paths) {
      if let id = viewModel.record?.id,
         coordinator.paths.last == .libraryDetail(id: id)
      {
        viewModel.send(.onAppear)
      }
    }
    .onChange(of: needRefresh) { oldValue, newValue in
      if newValue {
        viewModel.send(.onAppear)
        if showAddMenu { UINavigationBar.showOverlay(duration: 0.0) }
        needRefresh = false
      }
    }
    .overlay {
      ZStack {

        if showAddMenu {
          Color.black.opacity(0.2)
            .ignoresSafeArea(edges: .bottom)
        }
        
        AddActionView(coordinator: coordinator,
                      showAddMenu: $showAddMenu,
                      needRefresh: $needRefresh,
                      viewModel: viewModel)
        
      }
      .animation(.linear(duration: 0.298), value: showAddMenu)
      .onTapGesture {
        showAddMenu = false
        if showAddMenu { UINavigationBar.showOverlay(duration: 0.0) }
        else { UINavigationBar.removeOverlay(duration: 0.0) }
      }
    }
    .sheet(item: $coordinator.sheet, content: { route in
      coordinator.buildView(for: route)
        .presentationDetents([.height(viewModel.selectedState.preferredHeight)])
        .presentationDragIndicator(.hidden)
    })
    
  }
  
  // MARK: - (F)topBarTrailingButton
  private func topBarTrailingButton() -> some View {
    HStack(spacing: 4) {
      Button {
        viewModel.send(.onTapFavorite)
      } label: {
        if let isFavorite = viewModel.record?.isFavorite {
          Image(systemName: isFavorite ? SFSymbol.bookMarkFill.name : SFSymbol.bookMark.name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 22, height: 22)
        }
      }
      Button {
        showDeleteAlert = true
      } label: {
        Text("삭제")
          .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.4)
      }
    } // : HStack
    .foregroundColor(.green6)
  }
}

// MARK: - (S)AddActionView
private struct AddActionView: View {
  @ObservedObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @Binding var showAddMenu: Bool
  @Binding var needRefresh: Bool
  @ObservedObject var viewModel: RecordDetailViewModel
  
  var body: some View {
    VStack(alignment: .trailing, spacing: 16) {
      
      if showAddMenu {
        VStack(spacing: 16) {
          Button {
            guard let record = viewModel.record else { return }
            UINavigationBar.removeOverlay(duration: 0.0)
            coordinator
              .presentSheet(
                .updateRecord(
                  state: $viewModel.selectedState,
                  record: record,
                  onComplete: { isEdit in
                    if isEdit {
                      needRefresh = true
                      showAddMenu = false
                    }
                  }
                )
              )
            
          } label: {
            Text("독서 기록")
          }
          
          Button {
            guard let record = viewModel.record else { return }
            UINavigationBar.removeOverlay(duration: 0.0)
            self.showAddMenu = false
            coordinator.push(.memo(record: record))
          } label: {
            Text("메모 작성")
          }
          
          Button {
            guard let record = viewModel.record else { return }
            UINavigationBar.removeOverlay(duration: 0.0)
            self.showAddMenu = false
            coordinator.push(.sentenceInput(mode: .create(record: record)))
          } label: {
            Text("문장 수집")
          }
          
        }
        .foregroundStyle(.black)
        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.2)
        .frame(width: 150, height: 150)
        .background(.backgroundDefault)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
        .transition(.move(edge: .trailing).combined(with: .opacity))
      }
      
      Button {
        if !showAddMenu {
          UINavigationBar.showOverlay()
        } else {
          UINavigationBar.removeOverlay()
        }
        showAddMenu.toggle()
      } label: {
        Image(systemName: "plus")
          .font(.system(size: 26))
          .frame(width: 64, height: 64)
          .foregroundStyle(.orange3)
          .rotationEffect(.degrees(showAddMenu ? -45 : 0))
      }
      .background(
        Circle()
          .fill(Color.backgroundDefault)
          .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
      )
    }
    .padding(.trailing, 24)
    .padding(.bottom, 24)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
  }
}


#Preview {
  let recordID = DummyData.dummyRecords[2].id
  PreviewableContainer {
    NavigationStack {
      RecordDetailView(viewModel: .init(recordID: recordID))
        .environmentObject(Coordinator<MainRoute, SheetRoute>())
    }
  }
}
