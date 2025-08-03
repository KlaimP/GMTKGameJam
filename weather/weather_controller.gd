extends Node2D
class_name WeatherController


var cloudiness: float = 0.5
var cloud_speed: float = 0.05

var temperature: float = 15.
var temp_change: float = 0.1
var temp_edges: Vector2 = Vector2(-15., 35.)
var prev_temp: float = 0.

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

var arrow_diff = 0.001


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
<<<<<<< HEAD
=======
	#%Time.text = str(snapped(time, 0.01))
>>>>>>> origin/soilGrass
	
	time_passed += delta
	if last_checked + average_time < time_passed:
		last_checked = time_passed
		average[avg_types.DAY_NIGHT_RATIO][last_int] = %DayRatio.value
		average[avg_types.TEMPERATURE][last_int] = temperature
		average[avg_types.CLOUDINESS][last_int] = cloudiness
		average[avg_types.MOISTURE][last_int] = moisture
		last_int = (last_int + 1)%average_points
	
	
	
	%Clock.update(_time)
	
	var weather: Weather = weather_scripts[current_weather]
	
	var new = weather.change_cloudiness(cloudiness, _cloudiness, cloud_speed, delta)
	change_arrow(0 if abs(new-cloudiness) < arrow_diff * delta else (-1 if new < cloudiness else 1), %CloudArrow)
	cloudiness = new
	%Cloudiness.text = str(snapped(cloudiness, 0.01))
	
	if temperature > temp_edges.y:
		temperature = prev_temp
	new = weather.change_temperature(temperature, temp_edges, cloudiness, temp_change, time, delta)
	change_arrow(0 if abs(new-temperature) < arrow_diff * delta else (-1 if new < temperature else 1), %TemperatureArrow)
	temperature = new
	%Temperature.text = str(snapped(temperature, 0.1)) + " °C"
	prev_temp = temperature
	
	new = weather.change_moisture(time, cloudiness, moisture, moisture_speed, temperature, temp_edges, delta)
	change_arrow(0 if abs(new-moisture) < arrow_diff * delta else (-1 if new < moisture else 1), %MoistureArrow)
	moisture = new
	%Moisture.text = str(int(moisture * 100)) + "%"
	
	%Soil.add_moisture(weather.get_soil_moisutre())
	
	change_shader(time, cloudiness)


func change_arrow(direction: int, arrow: Node2D):
	if direction == 0:
		arrow.hide()
	if direction > 0:
		arrow.show()
		arrow.modulate = Color.LAWN_GREEN
		arrow.rotation = 0.
	if direction < 0:
		arrow.show()
		arrow.modulate = Color.DARK_RED
		arrow.rotation = PI


func next_weather():
	var ratio_sum = 0.
	for i in average[avg_types.DAY_NIGHT_RATIO]: ratio_sum += i
	var temp_sum = 0.
	for i in average[avg_types.TEMPERATURE]: temperature += i
	var cloud_sum = 0.
	for i in average[avg_types.CLOUDINESS]: cloud_sum += i
	var moist_sum = 0.
	for i in average[avg_types.MOISTURE]: moist_sum += i
	$Forecast.next_weather((ratio_sum/average_points + 1.)/2.,
							remap(temp_sum/average_points, temp_edges.x, temp_edges.y, 0., 1.),
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
	
	
