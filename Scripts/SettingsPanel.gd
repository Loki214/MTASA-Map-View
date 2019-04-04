extends Panel

onready var tween = get_node("Tween")
onready var blocker = get_parent().get_parent().get_node("UI/blocker")
onready var main = get_parent().get_parent().get_node("map")
onready var camera = get_parent().get_parent().get_node("Cam")
var mouseOnCol: bool
var inSettings: bool

func _ready():
	$host.grab_focus()
	$host.select()
	$host.connect("focus_entered",$host,"select")
	$user.connect("focus_entered",$user,"select")
	$pass.connect("focus_entered",$pass,"select")
	$host.connect("focus_exited",$host,"deselect")
	$user.connect("focus_exited",$user,"deselect")
	$pass.connect("focus_exited",$pass,"deselect")

func _on_SettingsCol_mouse_entered():
	var h = OS.window_size.y-40
	tween.interpolate_property(self, 'rect_position', self.rect_position, Vector2(0,h), .5, Tween.TRANS_QUAD, Tween.EASE_OUT, 0)
	tween.start()
	mouseOnCol = true

func _on_SettingsCol_mouse_exited():
	if tool.connected:
		var h = OS.window_size.y
		tween.interpolate_property(self, 'rect_position', self.rect_position, Vector2(0,h), .5, Tween.TRANS_QUAD, Tween.EASE_OUT, 0)
		tween.start()
	mouseOnCol = false

func onEnterPressed(event: InputEventKey):
	if event and event.as_text() == "Enter" and !event.pressed:
		if !$Button.pressed:
			main.loginUser($user.text,$pass.text,$host.text)
			$Button.pressed = true
			$Button.disabled = true
			if !$Timer.is_stopped():
				$Timer.stop()
			$Status.text = "Connecting..."
			$Status.modulate = Color(1,1,1)
			$Status.show()

func _on_Button_toggled(p):
	if p:
		main.loginUser($user.text,$pass.text,$host.text)
		$Button.disabled = true
		if !$Timer.is_stopped():
			$Timer.stop()
		$Status.text = "Connecting..."
		$Status.modulate = Color(1,1,1)
		$Status.show()
	else:
		main.logoutUser()
		blocker.show()
		$Button.text = "Connect"
		toggleFields(true)
		camera.initial()

var status = { 
	0: "Connection refused.",
	200: "Connection to resource failed.",
	401: "Incorrect or Unauthorized login details."
}

func _on_mta_connect_failed(reason):
	$Button.pressed = false
	$Button.text = "Connect"
	$Button.disabled = false
	blocker.show()
	$Status.show()
	$Timer.start()
	$Status.text = status[reason]
	$Status.modulate = Color(1,0,0)

func _on_mta_connect():
	camera.initial()
	$Button.disabled = false
	blocker.hide()
	$Status.show()
	$Timer.start()
	$Button.text = "Disconnect"
	$Status.text = "Connected."
	$Status.modulate = Color(0,1,0)
	toggleFields(false)
	tool.updateRate = 1
	$settingsPanel/HSlider.value = tool.updateRate

func _on_Timer_timeout():
	$Status.hide()
	if !mouseOnCol:
		_on_SettingsCol_mouse_exited()
	else:
		_on_SettingsCol_mouse_entered()

func toggleFields(state: bool):
	$host.editable = state
	$user.editable = state
	$pass.editable = state

func _on_settingsBtn_button_up():
	$settingsPanel.popup()
	inSettings = true


func _on_HSlider_value_changed(value):
	tool.updateRate = value
	$settingsPanel/rateEdit.text = str(value)


func _on_settingsPanel_popup_hide():
	inSettings = false
