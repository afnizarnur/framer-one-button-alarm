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

# Function
# Check if array null 
Array::present = ->
	@.length > 0

# Button Behaviour and States
purple = new Gradient
	start: "#532ED6"
	end: "#B28AF2"

purpleForce = new Gradient
	start: "#3B1FA5"
	end: "#331367"

addButton = button.children[0] 
checkButton = button.children[1] 
closeButton = button.children[2] 
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

closeButton.states =
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

# When Button onTap
button.onTap (event, layer) ->
	if this.states.current.name is "tapped"
		add_alarm.height = 210
		button.animate("normal")
		addButton.animate("active")
		checkButton.animate("hidden")
		closeButton.animate("hidden")
		maximize.stateSwitch("default")
		existing.stateSwitch("default")
		wrapper_empty.stateSwitch("hidden")
		if add_alarm.states.current.name is "full"
			add_alarm.animate("hiddenFull")
		else
			add_alarm.animate("hidden")
		
	else 
		button.animate("tapped")
		addButton.animate("hidden")
		checkButton.animate("active")
		closeButton.animate("hidden")
		add_alarm.animate("active")

timer = []

maximize.states =
	disable:
		opacity: .3
		animationOptions:
			time: .5
			curve: Bezier.ease

maximize.onTap (event, layer) ->
	if add_alarm.height <= 260
		add_alarm.animate("full")
	else if wrapper_empty.states.current.name is "active"
		add_alarm.animate("full")
	else
		add_alarm.animate("small")
		
scrollExisting = new ScrollComponent
	z: -1
	y: 50
	parent: add_alarm
	width: add_alarm.width
	height: 420
	scrollHorizontal: false

wrapper_content.parent = scrollExisting.content
wrapper_empty.parent = wrapper_content

wrapper_empty.states =
	active: 
		opacity: 1
		scale: 1
		x: Align.center
		animationOptions:
			time: .4
			curve: Spring
	hidden:
		opacity: 0
		scale: 0
		animationOptions:
			time: .4
			curve: Spring

wrapper_empty.stateSwitch("hidden")

existing.states =
	active:
		borderColor: "#7755CC"
		animationOptions:
			time: .3
			curve: Bezier.easeIn

existing.onTap (event, layer) ->
	if existing.states.current.name isnt "active"
		add_alarm.animate("full")
		if timer.present()
			existing.animate("active")
			print "Not empty timer"	
		else
			existing.animate("active")
			if wrapper_empty.states.current.name isnt "active"
				maximize.animate("disable")
				wrapper_content.height = 470 - 50
				scrollExisting.z = 0
				scrollExisting.scrollVertical = false
				addButton.animate("hidden")
				checkButton.animate("hidden")
				closeButton.animate("active")
				
				Utils.delay 0.3, ->
					wrapper_empty.animate("active")
	else 
		existing.stateSwitch("default")
		maximize.stateSwitch("default")
		addButton.animate("hidden")
		checkButton.animate("active")
		closeButton.animate("hidden")
		wrapper_empty.animate("hidden")


