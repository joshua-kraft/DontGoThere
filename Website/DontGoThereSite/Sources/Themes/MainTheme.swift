import Foundation
import Ignite

struct MyTheme: Theme {
  func render(page: Page, context: PublishingContext) -> HTML {
    HTML {
      Head(for: page, in: context)

      Body {
        HeaderBar()

        page.body

        IgniteFooter()
      }
      .padding(.vertical, 80)
    }
  }
}
