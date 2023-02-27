extends Projectile

const speed = 150

func _process(delta):
	position += transform.x * speed * delta

func _ready():
	self.friendly = false
	#damage = 1
func _on_KillTimer_timeout() -> void:
	queue_free()
