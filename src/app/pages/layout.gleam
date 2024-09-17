import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html.{body, head, html, meta, title}

pub fn layout(elements: List(Element(t))) -> Element(t) {
  html([], [
    head([], [
      title([], "Weather API"),
      meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1"),
      ]),
    ]),
    body([], elements),
  ])
}
