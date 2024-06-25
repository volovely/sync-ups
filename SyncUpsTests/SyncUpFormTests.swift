import ComposableArchitecture
import XCTest


@testable import SyncUps


class SyncUpFormTests: XCTestCase {
  @MainActor
   func testAddAttendee() async {
     let store = TestStore(
       initialState: SyncUpForm.State(
         syncUp: SyncUp(id: SyncUp.ID())
       )
     ) {
       SyncUpForm()
     } withDependencies: {
       $0.uuid = .incrementing
     }
     
     await store.send(.addAttendeeButtonTapped) {
       let attendee = Attendee(id: Attendee.ID(0))
       
       $0.focus = .attendee(attendee.id)
       $0.syncUp.attendees.append(attendee)
     }
   }
  
  @MainActor
  func testRemoveFocusedAttendee() async {
    let attendee1 = Attendee(id: Attendee.ID())
    let attendee2 = Attendee(id: Attendee.ID())
    let store = TestStore(
      initialState: SyncUpForm.State(
        syncUp: SyncUp(
          id: SyncUp.ID(),
          attendees: [attendee1, attendee2]
        ),
        focus: .attendee(attendee1.id)
      )
    ) {
      SyncUpForm()
    }
    
    await store.send(.onDeleteAttendees([0])) {
      $0.focus = .attendee(attendee2.id)
      $0.syncUp.attendees = [attendee2]
    }
  }
  
  @MainActor
  func testRemoveAttendee() async {
    let attendee1 = Attendee(id: Attendee.ID())
    let attendee2 = Attendee(id: Attendee.ID())
    let store = TestStore(
      initialState: SyncUpForm.State(
        syncUp: SyncUp(
          id: SyncUp.ID(),
          attendees: [attendee1, attendee2]
        ),
        focus: .title
      )
    ) {
      SyncUpForm()
    }
    
    await store.send(.onDeleteAttendees([0])) {
      $0.focus = .title
      $0.syncUp.attendees = [attendee2]
    }
  }
}
