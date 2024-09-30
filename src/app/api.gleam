import gleam/http/request
import gleam/http/response.{type Response as HttpResponse}
import gleam/httpc
import gleam/int
import gleam/json
import gleam/result
import wisp.{type Response}

const weather_api: String = "https://api.open-meteo.com/v1/forecast"

type HourlyUnits {
  HourlyUnits(time: String, temperature_2m: String)
}

type Hourly {
  Hourly(time: List(String), temperature_2m: List(Float))
}

type WeatherResponse {
  WeatherResponse(
    latitude: Float,
    longitude: Float,
    timezone: String,
    timezone_abbreviation: String,
    elevation: Float,
    hourly_units: HourlyUnits,
    hourly: Hourly,
  )
}

/// handler for getting weather forecast
pub fn get_weather() -> Response {
  case fetch_weather() {
    Ok(value) -> {
      json.string(value.body)
      |> json.to_string_builder
      |> wisp.json_response(200)
    }
    Error(msg) -> error_response(msg)
  }
}

// Fetch weather from weather api. See: https://open-meteo.com/en/docs
fn fetch_weather() -> Result(HttpResponse(String), String) {
  let forecast_query =
    "?latitude=44.4048&longitude=8.9444&hourly=temperature_2m"

  // build request for fetching weather
  let assert Ok(req) = request.to(weather_api <> forecast_query)

  // execute request
  let resp_result =
    httpc.send(req)
    |> result.replace_error(
      "Failed to make request to api.open-meteo.com with: " <> forecast_query,
    )

  // return response from api endpoint
  use resp <- result.try(resp_result)
  case resp.status {
    200 -> Ok(resp)
    _ ->
      Error(
        "Got status "
        <> int.to_string(resp.status)
        <> " from api.open-meteo.com: "
        <> forecast_query,
      )
  }
}

/// Create an error response from a message.
fn error_response(msg: String) -> Response {
  json.object([#("error", json.string(msg))])
  |> json.to_string_builder
  |> wisp.json_response(500)
}
