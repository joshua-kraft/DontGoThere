import Foundation
import Ignite

// swiftlint: disable line_length
struct Home: StaticPage {
  var title = "Home"

  func body(context: PublishingContext) -> [BlockElement] {
    Spacer()

    Text {
      Image("/images/AppIcon.png")
        .padding(.trailing, 25)
        .frame(width: "max(12.5%, 128px)", height: "max(12.5%, 128px)")

      "DontGoThere"
    }
    .font(.title1)
    .horizontalAlignment(.center)

    Text("A Bad Experience Tracker")
      .font(.title2)
      .horizontalAlignment(.center)

    Text("Never get caught off-guard by a bad experience again — let DontGoThere remind you to steer clear!")
      .font(.lead)
      .horizontalAlignment(.center)

    Group {
      Text("Ever found yourself back at a place that disappointed you, only to realize too late that you’d been there before and had a bad experience? DontGoThere is here to ensure you never make the same mistake twice!")

      Text("With DontGoThere, you can easily track places where you’ve had less-than-stellar experiences, complete with a name, address, review, and photos. The app will keep track of these places and send you a gentle reminder if you find yourself back in the vicinity.")

      Spacer()

      Text("Features: ")
        .font(.title4)

      Spacer()

      List {
        Text("iCloud Sync: All of your places are synchronized across your devices using iCloud - add a place with your iPhone in the moment, and edit it later on your iPad or Mac!")

        Text("Active and Archived Places: Only active places send you notifications, so you won’t be bothered about old grievances. When a place no longer needs your attention, it automatically archives itself, keeping your list tidy.")

        Text("Automatic Archiving: Set places to archive themselves after a certain period or after a specific number of reminders. Once archived, places will delete themselves after some time, unless you choose to keep them.")

        Text("Smart Notifications: Receive a reminder when you’re near a place you’ve marked, but only once per day. Customize the notification settings to suit your preferences, including how close you need to be to get alerted.")

        Text("Map and List Views: Browse your list of places or view them on a map with easy-to-spot icons that help you avoid trouble spots.")

        Text("Quick Add: Add places on the fly at your current location or anywhere on the map with just a tap.")

        Text("Search and Add: Find and mark specific places on the map to make sure you never accidentally return.")
      }

      Text("Install DontGoThere on your iPhone, iPad, or Mac from the App Store!")
    }
    .padding(.horizontal, 10)
  }
}
// swiftlint: enable line_length
