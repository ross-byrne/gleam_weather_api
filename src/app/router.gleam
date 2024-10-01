import app/pages/home
import app/weather
import app/weather/encodings
import app/web
import gleam/json
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    // Homepage
    [] -> get_home()
    ["weather"] -> get_weather()
    _ -> wisp.not_found()
  }
}

/// Get the home page for webserver
fn get_home() -> Response {
  home.root()
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

/// handler for getting weather forecast
fn get_weather() -> Response {
  case weather.get_decoded_api_response() {
    Ok(response) -> {
      encodings.api_response_encoder(response)
      |> json.to_string_builder
      |> wisp.json_response(200)
    }
    Error(msg) -> error_response(msg)
  }
}

/// Create an error response from a message.
fn error_response(msg: String) -> Response {
  json.object([#("error", json.string(msg))])
  |> json.to_string_builder
  |> wisp.json_response(500)
}
