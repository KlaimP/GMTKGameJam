extends Node2D



func update(time: float):
	if time > 0.:
		$Hand.rotation = lerp(PI/2., 3./2.*PI, time)
	else:
		$Hand.rotation = lerp(3./2.*PI, PI/2., -time) + PI
