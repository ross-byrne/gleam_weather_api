import app/pages/layout.{layout}
import lustre/element.{type Element, text}
import lustre/element/html.{h1}

pub fn root() -> Element(t) {
  [h1([], [text("Hello, Weather API!")])]
  |> layout
}
