pub const base_api: String = "https://api.open-meteo.com/v1/forecast?latitude=44.4048&longitude=8.9444&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,wind_speed_10m&timezone=Europe%2FBerlin"

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
