import Foundation
import Ignite

@main
struct IgniteWebsite {
  static func main() async {
    let site = DontGoThereSite()

    do {
      try await site.publish()
    } catch {
      print(error.localizedDescription)
    }
  }
}

struct DontGoThereSite: Site {
  var name = "Home"
  var titleSuffix = " - DontGoThere"
  var url = URL("http://dontgothere.app")
  var builtInIconsEnabled = true

  var author = "Joshua Kraft"

  var homePage = Home()
  var theme = MyTheme()

  var pages: [any StaticPage] {
    Privacy()
    Support()
  }
}