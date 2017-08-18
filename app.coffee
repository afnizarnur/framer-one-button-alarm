# Statusbar time
setTime = () ->
	date = new Date
	minute = date.getMinutes()
	hour = date.getHours()
	
	if hour < 10
		hour = '0' + hour 
	
	if minute < 10
		minute = '0' + minute 

	statusBarTime.text = "#{hour}:#{minute}"

	Utils.delay 30, ->
		setTime()
		
setTime()

# Button Behaviour and States
purple = new Gradient
	start: "#532ED6"
	end: "#B28AF2"

purpleForce = new Gradient
	start: "#3B1FA5"
	end: "#331367"

addButton = button.children[0] 
checkButton = button.children[1] 
checkButton.scale = 0
add_alarm.scale = 0	
add_alarm.y = 500	

button.states =
	normal:
		gradient: purple
		animationOptions:
			time: 1
			curve: Spring
	tapped:
		gradient: purpleForce
		animationOptions:
			time: 1
			curve: Spring
			
addButton.states =
	active: 
		opacity: 1
		scale: 1
		animationOptions:
			time: 0.4
			curve: Spring
	hidden: 
		opacity: 0
		scale: 0
		animationOptions:
			time: 0.4
			curve: Spring

checkButton.states =
	active:
		opacity: 1
		scale: 1
		animationOptions:
			time: 0.4
			curve: Spring
	hidden: 
		opacity: 0
		scale: 0
		animationOptions:
			time: 0.4
			curve: Spring
			
add_alarm.states =
	active:
		opacity: 1
		scale: 1
		y: 300
		animationOptions:
			time: .7
			curve: Spring
	hidden:
		opacity: 0
		scale: 0
		y: 500
		animationOptions:
			time: .7
			curve: Spring	
	full:
		height: 470
		y: 40
		animationOptions:
			time: .7
			curve: Spring
	small:
		height: 260
		y: 250
		animationOptions:
			time: .7
			curve: Spring
	hiddenFull:
		opacity: 0
		scale: 0
		y: 500
		animationOptions:
			time: 1.4
			curve: Spring

button.onTap (event, layer) ->
	if this.states.current.name is "tapped"
		add_alarm.height = 210
		button.animate("normal")
		addButton.animate("active")
		checkButton.animate("hidden")
		if add_alarm.states.current.name is "full"
			add_alarm.animate("hiddenFull")
		else
			add_alarm.animate("hidden")
	else 
		button.animate("tapped")
		addButton.animate("hidden")
		checkButton.animate("active")
		add_alarm.animate("active")

maximize.onTap (event, layer) ->
	if add_alarm.height <= 260
		add_alarm.animate("full")
	else
		add_alarm.animate("small")
	

scrollExisting = new ScrollComponent
scrollExisting.z = -1
scrollExisting.parent = add_alarm
scrollExisting.backgroundColor = "transparent"
scrollExisting.y = 0
scrollExisting.width = add_alarm.width
scrollExisting.height = 470
scrollExisting.scrollHorizontal = false
wrapper_content.parent = scrollExisting.content
wrapper_empty.parent = wrapper_content
wrapper_empty.x = Screen.width
	
existing.onTap (event, layer) ->
	wrapper_content.height = 470
	add_alarm.animate("full")
	wrapper_empty.x = Align.center
	scrollExisting.height = 470
	scrollExisting.z = 0