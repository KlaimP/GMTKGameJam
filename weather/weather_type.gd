extends Node
class_name Weather

@export var this_weather: weather_type

var prev_change: int = 0
var time_to_update: float = 20.


enum weather_type {
	CLEAR,
	CLOUDY,
	RAIN,
	THUNDER,
	SNOW,
	BLIZZARD,
	DROUGHT,
	MIST,
	SHARK_TORNADO
}



func end_weather():
	pass


func start_weather():
	prev_change = 0.


func change_weather(
	weather_time: float, temperature: float, cloudiness: float,
	moisture: float, time: float
	) -> int:
	
	var next = this_weather
	var t: int = weather_time/time_to_update
	if t > prev_change:
		next = next_weather(weather_time, temperature, cloudiness, moisture, time)
		prev_change = t
	
	return next

func next_weather(weather_time: float, temperature: float, cloudiness: float,
	moisture: float, time: float) -> int:
	return this_weather



func change_cloudiness(
	cloudiness: float, cloud_requered: float, cloud_speed: float, delta: float
	) -> float:
	
	cloudiness += (cloud_requered - cloudiness) * cloud_speed * delta
	return clamp(cloudiness, 0., 1.)


func change_temperature(
	temperature: float, temp_edges: Vector2, cloudiness: float,
	temp_change: float, time: float, delta: float
	) -> float:
	
	temperature += temp_change * time * (1.2 - cloudiness) * delta
	return clamp(temperature, temp_edges.x, temp_edges.y)


func change_moisture(
	time: float, cloudiness: float, moisture: float, moist_speed: float,
	temperature: float, temp_edges: Vector2, delta: float
	) -> float:
		
	var t_norm = (temperature + temp_edges.x) / temp_edges.y
	if time > 0.:
		moisture -= (0.5 + t_norm) * (1.1 - cloudiness) * moist_speed * delta
	else:
		moisture += (0.3 + 0.7 * cloudiness) * (1.1 - t_norm) * moist_speed * delta
	return clamp(moisture, 0.0, 1.0)
