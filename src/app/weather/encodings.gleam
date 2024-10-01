import app/weather/types.{type ApiResponse, type Current, type CurrentUnits}
import gleam/dynamic
import gleam/json

/// Decode weather api response
pub fn api_response_decoder() {
  dynamic.decode7(
    types.ApiResponse,
    dynamic.field("latitude", dynamic.float),
    dynamic.field("longitude", dynamic.float),
    dynamic.field("utc_offset_seconds", dynamic.int),
    dynamic.field("timezone", dynamic.string),
    dynamic.field("timezone_abbreviation", dynamic.string),
    dynamic.field("current_units", current_units_decorder()),
    dynamic.field("current", current_decoder()),
  )
}

/// Encode weather api response to return from api
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

fn current_units_decorder() {
  dynamic.decode7(
    types.CurrentUnits,
    dynamic.field("time", dynamic.string),
    dynamic.field("interval", dynamic.string),
    dynamic.field("temperature_2m", dynamic.string),
    dynamic.field("relative_humidity_2m", dynamic.string),
    dynamic.field("apparent_temperature", dynamic.string),
    dynamic.field("precipitation", dynamic.string),
    dynamic.field("wind_speed_10m", dynamic.string),
  )
}

fn current_units_encoder(current_units: CurrentUnits) {
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

fn current_decoder() {
  dynamic.decode7(
    types.Current,
    dynamic.field("time", dynamic.string),
    dynamic.field("interval", dynamic.int),
    dynamic.field("temperature_2m", dynamic.float),
    dynamic.field("relative_humidity_2m", dynamic.int),
    dynamic.field("apparent_temperature", dynamic.float),
    dynamic.field("precipitation", dynamic.float),
    dynamic.field("wind_speed_10m", dynamic.float),
  )
}

fn current_encoder(current: Current) {
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
