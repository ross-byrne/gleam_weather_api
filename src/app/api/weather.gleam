import gleam/dynamic
import gleam/json

pub const base_api: String = "https://api.open-meteo.com/v1/forecast?latitude=44.4048&longitude=8.9444&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,wind_speed_10m&timezone=Europe%2FBerlin"

// Current Units
pub type CurrentUnits {
  CurrentUnits(
    time: String,
    interval: String,
    temperature_2m: String,
    relative_humidity_2m: String,
    apparent_temperature: String,
    precipitation: String,
    wind_speed_10m: String,
  )
}

// Current
pub type Current {
  Current(
    time: String,
    interval: Int,
    temperature_2m: Float,
    relative_humidity_2m: Int,
    apparent_temperature: Float,
    precipitation: Float,
    wind_speed_10m: Float,
  )
}

// Weather Response
pub type ApiResponse {
  ApiResponse(
    latitude: Float,
    longitude: Float,
    utc_offset_seconds: Int,
    timezone: String,
    timezone_abbreviation: String,
    current_units: CurrentUnits,
    current: Current,
  )
}

pub fn current_units_decorder() {
  dynamic.decode7(
    CurrentUnits,
    dynamic.field("time", dynamic.string),
    dynamic.field("interval", dynamic.string),
    dynamic.field("temperature_2m", dynamic.string),
    dynamic.field("relative_humidity_2m", dynamic.string),
    dynamic.field("apparent_temperature", dynamic.string),
    dynamic.field("precipitation", dynamic.string),
    dynamic.field("wind_speed_10m", dynamic.string),
  )
}

pub fn current_units_encoder(current_units: CurrentUnits) {
  json.object([
    #("time", json.string(current_units.time)),
    #("interval", json.string(current_units.interval)),
    #("temperature_2m", json.string(current_units.temperature_2m)),
    #("relative_humidity_2m", json.string(current_units.relative_humidity_2m)),
    #("apparent_temperature", json.string(current_units.apparent_temperature)),
    #("precipitation", json.string(current_units.precipitation)),
    #("wind_speed_10m", json.string(current_units.wind_speed_10m)),
  ])
}

pub fn current_decoder() {
  dynamic.decode7(
    Current,
    dynamic.field("time", dynamic.string),
    dynamic.field("interval", dynamic.int),
    dynamic.field("temperature_2m", dynamic.float),
    dynamic.field("relative_humidity_2m", dynamic.int),
    dynamic.field("apparent_temperature", dynamic.float),
    dynamic.field("precipitation", dynamic.float),
    dynamic.field("wind_speed_10m", dynamic.float),
  )
}

pub fn current_encoder(current: Current) {
  json.object([
    #("time", json.string(current.time)),
    #("interval", json.int(current.interval)),
    #("temperature_2m", json.float(current.temperature_2m)),
    #("relative_humidity_2m", json.int(current.relative_humidity_2m)),
    #("apparent_temperature", json.float(current.apparent_temperature)),
    #("precipitation", json.float(current.precipitation)),
    #("wind_speed_10m", json.float(current.wind_speed_10m)),
  ])
}

pub fn api_response_decoder() {
  dynamic.decode7(
    ApiResponse,
    dynamic.field("latitude", dynamic.float),
    dynamic.field("longitude", dynamic.float),
    dynamic.field("utc_offset_seconds", dynamic.int),
    dynamic.field("timezone", dynamic.string),
    dynamic.field("timezone_abbreviation", dynamic.string),
    dynamic.field("current_units", current_units_decorder()),
    dynamic.field("current", current_decoder()),
  )
}

pub fn api_response_encoder(response: ApiResponse) {
  json.object([
    #("latitude", json.float(response.latitude)),
    #("longitude", json.float(response.longitude)),
    #("utc_offset_seconds", json.int(response.utc_offset_seconds)),
    #("timezone", json.string(response.timezone)),
    #("timezone_abbreviation", json.string(response.timezone_abbreviation)),
    #("current_units", current_units_encoder(response.current_units)),
    #("current", current_encoder(response.current)),
  ])
}
