require_relative "zed_essence_outside"

class ZedAsteroid < GameObject
  def initialize(scene, position)
    sprite = sprite image(image_path("zed_asteroid.png")), at: position.to_vector2 + [0, 5]
    sprite.origin = sprite.image.size / 2

    super(scene, sprite, position)

    self.z = 5 # So exploding pixels don't stuck.

    @glow = sprite image(image_path("glow.png")), color: Color.new(150, 0, 150, 150)
    @glow.blend_mode = :add
    @glow.origin = @glow.image.size / 2
    @glow.scale *= 0.125
    @explosion = sound sound_path("asteroid_explosion.ogg")
    @explosion.volume = 50 * (scene.user_data.effects_volume / 50.0)
  end

  def update
    self.x -= 1
    self.y += 0.15
    @sprite.angle += 50 * frame_time

    @glow.pos = @sprite.pos

    if @sprite.x < 20
      explode_pixels(gravity: 0, number: 4,
                     velocity: [-5, 0, 0], random_velocity: [10, 10, 0],
                     min_y: -Float::INFINITY, max_y: Float::INFINITY, fade_duration: 10)

      explode_pixels(gravity: 0, number: 2, glow: true,
                     velocity: [-5, 0, 0], random_velocity: [20, 20, 0],
                     min_y: -Float::INFINITY, max_y: Float::INFINITY, fade_duration: 2,
                     color: ZedEssenceOutside::COLOR, scale: 3)

      @explosion.play
      ZedEssenceOutside.new(scene, [x, y])

      scene.remove_object(self)
    end
  end

  def draw_on(win)
    win.draw @sprite
    win.draw @glow
  end
end