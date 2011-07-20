require_relative "dynamic_object"

class Spring < DynamicObject
  JUMP_SPEED = 3

  def to_rect; Rect.new(@sprite.x - 2, @sprite.y - 1, 4, 2) end

  def initialize(scene, position)
    sprite = sprite image_path("spring.png"), at: position
    sprite.sheet_size = [2, 1]
    sprite.origin = Vector2[sprite.sprite_width, sprite.sprite_height] / 2 + [-1, 0.5]

    @activated = false
    super(scene, sprite, position)
  end

  def z_order
    @activated ? super : -1000
  end

  def update
    player = scene.player

    if not @activated and collide? player
      @sprite.sheet_pos = [1, 0]
      # Todo: Boing sound.
      player.z += 0.000001 # Just so we only collide with ONE spring.
      player.velocity_z = JUMP_SPEED
      @activated = true
    end

    super
  end
end
