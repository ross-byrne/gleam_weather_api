import app/api/weather.{type ApiResponse}
import gleam/http/request
import gleam/http/response.{type Response as HttpResponse}
import gleam/httpc
import gleam/int
import gleam/json
import gleam/result
import gleam/string
import wisp.{type Response}

/// handler for getting weather forecast
pub fn get_weather() -> Response {
  case get_weather_api_result() {
    Ok(response) -> {
      weather.api_response_encoder(response)
      |> json.to_string_builder
      |> wisp.json_response(200)
    }
    Error(msg) -> error_response(msg)
  }
}

/// Fetch weather from weather api. See: https://open-meteo.com/en/docs
fn fetch_weather() -> Result(HttpResponse(String), String) {
  // build request for fetching weather
  let assert Ok(req) = request.to(weather.base_api)

  // execute request
  let resp_result =
    httpc.send(req)
    |> result.replace_error("Failed to make request to api.open-meteo.com")

  // return response from api endpoint
  use resp <- result.try(resp_result)
  case resp.status {
    200 -> Ok(resp)
    _ ->
      Error(
        "Got status "
        <> int.to_string(resp.status)
        <> " from api.open-meteo.com",
      )
  }
}

fn get_weather_api_result() -> Result(ApiResponse, String) {
  use resp <- result.try(fetch_weather())

  case json.decode(from: resp.body, using: weather.api_response_decoder()) {
    Ok(response) -> Ok(response)
    // Error(decode_error) -> Error("Failed to get Response from Weather API")
    // TODO: For debugging, remove
    Error(decode_error) -> Error(string.inspect(decode_error))
  }
}

/// Create an error response from a message.
fn error_response(msg: String) -> Response {
  json.object([#("error", json.string(msg))])
  |> json.to_string_builder
  |> wisp.json_response(500)
}
