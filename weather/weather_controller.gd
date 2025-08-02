extends Node2D
class_name WeatherController


var cloudiness: float = 0.5
var cloud_speed: float = 0.2

var temperature: float = 23.
var temp_change: float = 0.5
var temp_edges: Vector2 = Vector2(-15., 35.)

var moisture: float = 0.5
var moisture_speed: float = 0.01

var day_night_ratio: float
var ratio_speed: float = 0.05

enum avg_types {
	DAY_NIGHT_RATIO,
	TEMPERATURE,
	CLOUDINESS,
	MOISTURE
}
var average: Dictionary[avg_types, Array]
var average_points: int = 12
var average_time: float = 0.5


@export var day_sky_color: Color
@export var night_sky_color: Color
@export var morning_sky_color: Color

@export var day_cloud_color: Color
@export var night_cloud_color: Color
@export var morning_cloud_color: Color


var current_weather: int = 0
var weather_time: float = 0.
@export var weather_scripts: Array[Weather]


func _ready() -> void:
	Events.change_weather.connect(change_weather)



func update(_time: float, _cloudiness: float, delta: float):
	var time = -(abs(_time) - 0.5) * 2.
	%Time.text = str(snapped(time, 0.01))
	
	$Clock.update(_time)
	
	var weather: Weather = weather_scripts[current_weather]
	
	cloudiness = weather.change_cloudiness(cloudiness, _cloudiness, cloud_speed, delta)
	$Cloudiness.text = str(snapped(cloudiness, 0.01))
	
	weather_time += delta
	day_night_ratio += time * ratio_speed * delta
	day_night_ratio = clamp(day_night_ratio, -1., 1.)
	
	temperature = weather.change_temperature(temperature, temp_edges, cloudiness, temp_change, time, delta)
	$Temperature.text = str(snapped(temperature, 0.1)) + " °C"
	
	moisture = weather.change_moisture(time, cloudiness, moisture, moisture_speed, temperature, temp_edges, delta)
	$Moisture.text = str(int(moisture * 100)) + "%"
	
	%Soil.add_moisture(weather.get_soil_moisutre())
	
	change_shader(time, cloudiness)



func change_weather(next: int):
	var weather: Weather = weather_scripts[current_weather]
	if next != current_weather:
		weather.end_weather()
		current_weather = next
		weather = weather_scripts[current_weather]
		weather_time = 0.
		weather.start_weather()



	
func change_shader(time: float, cloudiness: float):
	$Sky.material.set_shader_parameter("cloudiness", cloudiness)
	if time < 0.:
		$Sky.material.set_shader_parameter("sky_color", lerp(morning_sky_color, night_sky_color, -time))
		$Sky.material.set_shader_parameter("cloud_color", lerp(morning_cloud_color, night_cloud_color, -time))
	else:
		$Sky.material.set_shader_parameter("sky_color", lerp(morning_sky_color, day_sky_color, time))
		$Sky.material.set_shader_parameter("cloud_color", lerp(morning_cloud_color, day_cloud_color, time))
	
	
