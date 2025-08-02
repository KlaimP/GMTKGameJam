extends Weather


func start_weather():
	super.start_weather()
	$BlizzardEffect.show()
	$BlizzardBackground.show()

func end_weather():
	super.end_weather()
	$BlizzardEffect.hide()
	$BlizzardBackground.hide()


	
