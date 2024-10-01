import app/weather/encodings
import app/weather/types.{type ApiResponse}
import gleam/http/request
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/int
import gleam/json
import gleam/result

/// Decode weather api response
pub fn get_decoded_api_response() -> Result(ApiResponse, String) {
  use resp <- result.try(fetch_weather())

  case json.decode(from: resp.body, using: encodings.api_response_decoder()) {
    Ok(response) -> Ok(response)
    Error(_) -> Error("Failed to get Response from Weather API")
  }
}

/// Fetch weather from weather api. See: https://open-meteo.com/en/docs
fn fetch_weather() -> Result(Response(String), String) {
  // build request for fetching weather
  let assert Ok(req) = request.to(types.base_api)

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
