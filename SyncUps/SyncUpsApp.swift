import SwiftUI
import ComposableArchitecture

@main
struct SyncUpsApp: App {
  @MainActor
  static let store = Store(initialState: SyncUpsList.State()) {
    SyncUpsList()
  }
  
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        AppView(store: Store(initialState: AppFeature.State()) {
          AppFeature()
        })
      }
    }
  }
}
