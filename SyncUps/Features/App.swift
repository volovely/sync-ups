import ComposableArchitecture
import SwiftUI


@Reducer
struct AppFeature {
  @Reducer(state: .equatable)
  enum Path {
    case detail(SyncUpDetail)
    case meeting(Meeting, syncUp: SyncUp)
    case record(RecordMeeting)
  }
  
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var syncUpsList = SyncUpsList.State()
  }
  enum Action {
    case path(StackActionOf<Path>)
    case syncUpsList(SyncUpsList.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.syncUpsList, action: \.syncUpsList) {
      SyncUpsList()
    }
    Reduce { state, action in
      switch action {
      case .path:
        return .none
      case .syncUpsList:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

struct AppView: View {
  @Bindable var store: StoreOf<AppFeature>


  var body: some View {
    NavigationStack(
      path: $store.scope(state: \.path, action: \.path)
    ) {
      SyncUpsListView(
        store: store.scope(state: \.syncUpsList, action: \.syncUpsList)
      )
    } destination: { store in
      switch store.case {
      case let .detail(detailStore):
        SyncUpDetailView(store: detailStore)
      case let .meeting(meeting, syncUp: syncUp):
        MeetingView(meeting: meeting, syncUp: syncUp)
      case let .record(recordStore):
        RecordMeetingView(store: recordStore)
      }        
    }
  }
}

#Preview {
  @Shared(.syncUps) var syncUps = [
      SyncUp(
        id: SyncUp.ID(),
        attendees: [
          Attendee(id: Attendee.ID(), name: "Blob"),
          Attendee(id: Attendee.ID(), name: "Blob Jr"),
          Attendee(id: Attendee.ID(), name: "Blob Sr"),
        ],
        duration: .seconds(6),
        meetings: [],
        theme: .orange,
        title: "Morning Sync"
      )
    ]
  
  return AppView(
    store: Store(
      initialState: AppFeature.State(
        syncUpsList: SyncUpsList.State()
      )
    ) {
      AppFeature()
    }
  )
}
