extends Node2D
class_name WeatherController


var cloudiness: float = 0.5
var cloud_speed: float = 0.2

var temperature: float = 23.
var temp_change: float = 0.5
var temp_edges: Vector2 = Vector2(-15., 35.)

var moisture: float = 0.5
var moisture_speed: float = 0.01


enum avg_types {
	DAY_NIGHT_RATIO,
	TEMPERATURE,
	CLOUDINESS,
	MOISTURE
}
var average: Dictionary[avg_types, Array]
var average_points: int = 20
var average_time: float = 5.
var last_checked: float = -1.5
var last_int: int = 0


var time_passed: float = 0.


@export var day_sky_color: Color
@export var night_sky_color: Color
@export var morning_sky_color: Color

@export var day_cloud_color: Color
@export var night_cloud_color: Color
@export var morning_cloud_color: Color


var current_weather: int = 0
@export var weather_scripts: Array[Weather]


func _ready() -> void:
	Events.day_ends.connect(next_weather)
	Events.change_weather.connect(change_weather)
	average[avg_types.DAY_NIGHT_RATIO] = []
	average[avg_types.DAY_NIGHT_RATIO].resize(average_points)
	average[avg_types.DAY_NIGHT_RATIO].fill(0.)
	average[avg_types.TEMPERATURE] = []
	average[avg_types.TEMPERATURE].resize(average_points)
	average[avg_types.TEMPERATURE].fill(temperature)
	average[avg_types.CLOUDINESS] = []
	average[avg_types.CLOUDINESS].resize(average_points)
	average[avg_types.CLOUDINESS].fill(cloudiness)
	average[avg_types.MOISTURE] = []
	average[avg_types.MOISTURE].resize(average_points)
	average[avg_types.MOISTURE].fill(moisture)



func update(_time: float, _cloudiness: float, delta: float):
	var time = -(abs(_time) - 0.5) * 2.
	%Time.text = str(snapped(time, 0.01))
	
	time_passed += delta
	if last_checked + average_time < time_passed:
		last_checked = time_passed
		average[avg_types.DAY_NIGHT_RATIO][last_int] = %DayRatio.value
		average[avg_types.TEMPERATURE][last_int] = temperature
		average[avg_types.CLOUDINESS][last_int] = cloudiness
		average[avg_types.MOISTURE][last_int] = moisture
		last_int = (last_int + 1)%average_points
	
	
	
	$Clock.update(_time)
	
	var weather: Weather = weather_scripts[current_weather]
	
	cloudiness = weather.change_cloudiness(cloudiness, _cloudiness, cloud_speed, delta)
	$Cloudiness.text = str(snapped(cloudiness, 0.01))
	
	temperature = weather.change_temperature(temperature, temp_edges, cloudiness, temp_change, time, delta)
	$Temperature.text = str(snapped(temperature, 0.1)) + " °C"
	
	moisture = weather.change_moisture(time, cloudiness, moisture, moisture_speed, temperature, temp_edges, delta)
	$Moisture.text = str(int(moisture * 100)) + "%"
	
	%Soil.add_moisture(weather.get_soil_moisutre())
	
	change_shader(time, cloudiness)


func next_weather():
	var ratio_sum = 0.
	for i in average[avg_types.DAY_NIGHT_RATIO]: ratio_sum += i
	var temp_sum = 0.
	for i in average[avg_types.TEMPERATURE]: temperature += i
	var cloud_sum = 0.
	for i in average[avg_types.CLOUDINESS]: cloud_sum += i
	var moist_sum = 0.
	for i in average[avg_types.MOISTURE]: moist_sum += i
	$Forecast.next_weather(ratio_sum/average_points, temp_sum/average_points,
							cloud_sum/average_points, moist_sum/average_points)


func change_weather(next: int):
	var weather: Weather = weather_scripts[current_weather]
	if next != current_weather:
		weather.end_weather()
		current_weather = next
		weather = weather_scripts[current_weather]
		weather.start_weather()



	
func change_shader(time: float, _cloudiness: float):
	$Sky.material.set_shader_parameter("cloudiness", _cloudiness)
	if time < 0.:
		$Sky.material.set_shader_parameter("sky_color", lerp(morning_sky_color, night_sky_color, -time))
		$Sky.material.set_shader_parameter("cloud_color", lerp(morning_cloud_color, night_cloud_color, -time))
	else:
		$Sky.material.set_shader_parameter("sky_color", lerp(morning_sky_color, day_sky_color, time))
		$Sky.material.set_shader_parameter("cloud_color", lerp(morning_cloud_color, day_cloud_color, time))
	
	
