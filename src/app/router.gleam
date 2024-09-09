import app/web
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    // Homepage
    [] -> {
      show_home()
    }

    _ -> wisp.not_found()
  }
}

pub fn show_home() -> Response {
  // In a larger application a template library or HTML form library might
  // be used here instead of a string literal.
  let html =
    string_builder.from_string(
      "<div>
        <h1>Hello, Weather API!</h1>
      </div>",
    )
  wisp.ok()
  |> wisp.html_body(html)
}
