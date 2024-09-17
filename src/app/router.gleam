import app/pages/home
import app/web
import lustre/element
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
  home.root()
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}
