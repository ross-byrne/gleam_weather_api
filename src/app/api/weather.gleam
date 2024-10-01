import gleam/dynamic

// Hourly Units
pub type HourlyUnits {
  HourlyUnits(time: String, temperature_2m: String)
}

pub fn hourly_units_decorder() {
  dynamic.decode2(
    HourlyUnits,
    dynamic.field("time", dynamic.string),
    dynamic.field("temperature_2m", dynamic.string),
  )
}

// Hourly
pub type Hourly {
  Hourly(time: List(String), temperature_2m: List(Float))
}

pub fn hourly_decoder() {
  dynamic.decode2(
    Hourly,
    dynamic.field("time", dynamic.list(dynamic.string)),
    dynamic.field("temperature_2m", dynamic.list(dynamic.float)),
  )
}

// Weather Response
pub type WeatherResponse {
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

pub fn weather_response_decoder() {
  dynamic.decode7(
    WeatherResponse,
    dynamic.field("latitude", dynamic.float),
    dynamic.field("longitude", dynamic.float),
    dynamic.field("timezone", dynamic.string),
    dynamic.field("timezone_abbreviation", dynamic.string),
    dynamic.field("elevation", dynamic.float),
    dynamic.field("hourly_units", hourly_units_decorder()),
    dynamic.field("hourly", hourly_decoder()),
  )
}
