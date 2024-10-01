import app/pages/layout.{layout}
import lustre/attribute.{href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, h1, h2}

pub fn root() -> Element(t) {
  [
    h1([], [text("Hello, Weather API!")]),
    a([href("/weather")], [h2([], [text("Get Weather Forecast")])]),
  ]
  |> layout
}
