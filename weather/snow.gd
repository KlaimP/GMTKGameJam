extends Weather


func start_weather():
	super.start_weather()
	$SnowEffect.show()
	$SnowBackground.show()

func end_weather():
	super.end_weather()
	$SnowEffect.hide()
	$SnowBackground.hide()


	
