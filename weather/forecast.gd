extends Node2D



var days_in_forecast: int = 7

@export var day: PackedScene

var weather_size: Vector2 = Vector2(50, 50)
@export var weather_array: Array

var ui_offset: int = 7
var ui_spacing: int = 5


var choosed: int = -1
var previous_weather: int = 0


var NOISE_SCALE: float = 0.1




func next_weather(day_night: float, temperature: float, cloudiness: float, moisture: float):
	Events.change_weather.emit(weather_array[0].weather)
	for i in range(1, days_in_forecast):
		weather_array[i - 1].set_weather(weather_array[i].weather)
	
	weather_array[days_in_forecast - 1].set_weather(decide_weather(day_night, temperature,
																	cloudiness, moisture))


func decide_weather(day_night: float, temperature: float, cloudiness: float, moisture: float) -> int:
	var weather_chances: Array
	weather_chances.resize(7)
	weather_chances[0] = 0.5
	weather_chances[1] = score_rain(day_night, temperature, cloudiness, moisture)
	weather_chances[2] = score_thunder(day_night, temperature, cloudiness, moisture)
	weather_chances[3] = score_snow(day_night, temperature, cloudiness, moisture)
	weather_chances[4] = score_blizzard(day_night, temperature, cloudiness, moisture)
	weather_chances[5] = score_drought(day_night, temperature, cloudiness, moisture)
	weather_chances[6] = score_mist(day_night, temperature, cloudiness, moisture)
	
	
	for i in range(weather_chances.size()):
		weather_chances[i] += (randf() - 0.5) * NOISE_SCALE
	
	return randi()%7



func score_rain(day_night, temp, cloudiness, moisture):
	var score = 0.2
	if cloudiness > 0.5:
		score += 0.3
	if cloudiness > 0.8:
		score += 0.2
	if moisture > 0.7:
		score += 0.2
	if temp < 0.3:
		score = 0.
	return score

func score_thunder(day_night, temp, cloudiness, moisture):
	var score = 0.1
	if cloudiness > 0.5:
		score += 0.2
	if cloudiness > 0.8:
		score += 0.4
	if moisture > 0.8:
		score += 0.2
	if temp < 0.3:
		score = 0.
	return score

func score_snow(day_night, temp, cloudiness, moisture):
	var score = 0.2
	if cloudiness > 0.4:
		score += 0.3
	if cloudiness > 0.7:
		score += 0.2
	if moisture > 0.5:
		score += 0.2
	if temp > 0.4:
		score = 0.
	return score

func score_blizzard(day_night, temp, cloudiness, moisture):
	var score = 0.2
	if cloudiness > 0.6:
		score += 0.3
	if cloudiness > 0.9:
		score += 0.3
	if moisture > 0.7:
		score += 0.2
	if temp > 0.3:
		score = 0.
	return score

func score_drought(day_night, temp, cloudiness, moisture):
	var score = 0.0
	if day_night > 0.5:
		score += 0.3
	if cloudiness < 0.5:
		score += 0.1
	if cloudiness < 0.3:
		score += 0.3
	if moisture > 0.5:
		score -= 0.2
	if moisture < 0.3:
		score += 0.3
	if temp < 0.5:
		score -= 0.2
	if temp > 0.8:
		score += 0.2
	return score

func score_mist(day_night, temp, cloudiness, moisture):
	var score = 0.2
	if day_night < 0.5:
		score += 0.2
	if moisture > 0.5:
		score += 0.2
	if moisture > 0.8:
		score += 0.2
	if temp < 0.4:
		score = 0.
	return score





func choosed_day(day: int):
	if choosed < 0:
		choosed = day
	else:
		var w = weather_array[day].weather
		weather_array[day].set_weather(weather_array[choosed].weather)
		weather_array[choosed].set_weather(w)
		choosed = -1




func _ready() -> void:
	Events.choosed_day.connect(choosed_day)
	weather_array.resize(days_in_forecast)
	$ForecastBackground.size = Vector2(
		ui_offset * 2 + days_in_forecast * weather_size.x + (days_in_forecast - 1) * ui_spacing,
		ui_offset * 2 + weather_size.y)
	for i in range(days_in_forecast):
		var d = day.instantiate()
		add_child(d)
		d.day = i
		weather_array[i] = d
		d.position = Vector2(ui_offset + i * (ui_spacing + weather_size.x) + weather_size.x/2, 
								ui_offset + weather_size.y/2)
		d.get_children()[0].shape.size = weather_size
		if i < 3:
			d.set_weather(0)
		else:
			d.set_weather(randi()%2)
		#wee woo wee woo
		
	
	
	
	
	
