extends Node
class_name Weather

@export var temp_rise: float = 1.
@export var moist_change: float = 1.
@export var cloud_change: float = 1.

enum weather_type {
	CLEAR,
	RAIN,
	THUNDER,
	SNOW,
	BLIZZARD,
	DROUGHT,
	MIST
}



func end_weather():
	pass


func start_weather():
	pass


func get_soil_moisutre() -> float:
	return 0.



func change_cloudiness(
	cloudiness: float, cloud_requered: float, cloud_speed: float, delta: float
	) -> float:
	
	cloudiness += (cloud_requered - cloudiness) * cloud_change * cloud_speed * delta
	return clamp(cloudiness, 0., 1.)


func change_temperature(
	temperature: float, temp_edges: Vector2, cloudiness: float,
	temp_change: float, time: float, delta: float
	) -> float:
	
	temperature += (temp_change * time * (1.0 - cloudiness) * temp_rise) * delta
	return clamp(temperature, temp_edges.x, temp_edges.y)


func change_moisture(
	time: float, cloudiness: float, moisture: float, moist_speed: float,
	temperature: float, temp_edges: Vector2, delta: float
	) -> float:
		
	var t_norm = (temperature + temp_edges.x) / temp_edges.y
	if time > 0.:
		moisture -= (0.5 + t_norm) * (1. - cloudiness) * moist_change * moist_speed * delta
	else:
		moisture += (0.1 + 0.7 * cloudiness) * (1. - t_norm) * moist_change * moist_speed * delta
	return clamp(moisture, 0.0, 1.0)
