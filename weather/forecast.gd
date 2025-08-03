extends Node2D



var days_in_forecast: int = 7

@export var day: PackedScene

var weather_size: Vector2 = Vector2(50, 50)
@export var weather_array: Array

var ui_offset: int = 7
var ui_spacing: int = 5


var choosed: int = -1




func next_weather(day_night: float, temperature: float, cloudiness: float, moisture: float):
	Events.change_weather.emit(weather_array[0].weather)
	for i in range(1, days_in_forecast):
		weather_array[i - 1].set_weather(weather_array[i].weather)
	
	weather_array[days_in_forecast - 1].set_weather(decide_weather(day_night, temperature,
																	cloudiness, moisture))


func decide_weather(day_night: float, temperature: float, cloudiness: float, moisture: float) -> int:
	var weather_chances: Array
	weather_chances.resize(7)
	weather_chances[0] = score_clear(day_night, temperature, cloudiness, moisture)
	weather_chances[1] = score_rain(day_night, temperature, cloudiness, moisture)
	weather_chances[2] = score_thunder(day_night, temperature, cloudiness, moisture)
	weather_chances[3] = score_snow(day_night, temperature, cloudiness, moisture)
	weather_chances[4] = score_blizzard(day_night, temperature, cloudiness, moisture)
	weather_chances[5] = score_drought(day_night, temperature, cloudiness, moisture)
	weather_chances[6] = score_mist(day_night, temperature, cloudiness, moisture)
	
	var choice = [0, 0]
	for i in range(1, weather_chances.size()):
		for c in range(choice.size()):
			if weather_chances[i] > weather_chances[choice[c]]:
				choice[c] = i
				break
	
	var rand = randf()
	var closest = 0
	var diff = 1.
	for c in range(choice.size()):
		if abs(choice[c] - rand) < diff:
			closest = c
			diff = abs(choice[c] - rand)
	
	return choice.pick_random()


func score_clear(day_night, temp, cloudiness, moisture):
	var score = (1.0 - cloudiness) + (1.0 - moisture) + (0.5 + 0.5 * day_night)
	return score/3.

func score_rain(day_night, temp, cloudiness, moisture):
	var temp_factor = smoothstep(0.3, 0.75, temp)
	var score = cloudiness + moisture + temp_factor
	return score/3.

func score_thunder(day_night, temp, cloudiness, moisture):
	var temp_factor = smoothstep(0.5, 1.0, temp)
	var score = cloudiness + moisture + temp_factor + (0.5 + 0.5 * day_night)
	return score/4.

func score_snow(day_night, temp, cloudiness, moisture):
	var score = cloudiness + moisture + (1. - smoothstep(0.2, 0.4, temp))
	return score/3.

func score_blizzard(day_night, temp, cloudiness, moisture):
	var score = (1. - smoothstep(0.0, 0.3, temp)) + cloudiness + moisture + (1.0 - day_night)
	return score/4.

func score_drought(day_night, temp, cloudiness, moisture):
	var score = temp + (1.0 - moisture) + (1.0 - cloudiness) + (0.5 + 0.5 * day_night)
	return score/4.


func score_mist(day_night, temp, cloudiness, moisture):
	var temp_pref = 1.0 - abs(remap(temp, 0.0, 1.0, 0.5, 0.5) - 0.5)
	var score = moisture + smoothstep(0.3, 0.8, cloudiness) + (1.0 - day_night) + temp_pref
	return score/4.




func choosed_day(day: int):
	if choosed < 0:
		choosed = day
	else:
		var w = weather_array[day].weather
		weather_array[day].set_weather(weather_array[choosed].weather)
		weather_array[choosed].set_weather(w)
		choosed = -1




func _ready() -> void:
	print(decide_weather(0.5, 0.8, 0.9, 0.9))
	print(decide_weather(0.1, 0.1, 0.9, 0.9))
	print(decide_weather(0.1, 0.1, 0.1, 0.1))
	print(decide_weather(0.9, 0.5, 0.9, 0.9))
	print(decide_weather(0.8, 0.1, 0.9, 0.1))
	print(decide_weather(0.5, 0.8, 0.1, 0.1))
	print(decide_weather(0.9, 0.9, 0.9, 0.1))
	print(decide_weather(0.5, 0.8, 0.5, 0.5))
	print(decide_weather(0.5, 0.1, 0.5, 0.5))
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
		
	
	
	
	
	
