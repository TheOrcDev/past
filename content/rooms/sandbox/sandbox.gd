extends Room
## Sandbox (placeholder cathedral). Hotspot verbs are methods named <verb>_<hotspot_id>.
## The altar has no handler on purpose: it exercises the fallback lines.


func look_statue() -> void:
	await Say.line(&"sandbox", &"statue_look")
