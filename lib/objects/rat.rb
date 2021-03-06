require_relative "game_object"
require_relative "float_icon"

class Rat < GameObject
  OK_SPRITE = [0, 0]
  CHASED_SPRITE = [1, 0]
  SQUASHED_SPRITE = [2, 0]

  SQUASHED_EXTRA_TIME = 1 # Extra 1 second when you squash/eat the mouse.
  TOUCHED_SCORE = 250
  SQUASHED_SCORE = 1000
  RUN_SPEED = -40

  def casts_shadow?; @state != :squashed; end
  def z_order; @state == :squashed ? Player::Z_ORDER_SQUASHED - 1 : super; end
  def to_rect; Rect.new(*(@position - [2, 1.5]), 4, 3) end

  def initialize(map, tile, position)
    sprite = sprite image_path("rat.png"), at: position
    sprite.sheet_size = [5, 1]
    sprite.origin = Vector2[sprite.sprite_width / 2, sprite.sprite_height - 1]
    sprite.scale = [0.75, 0.75]

    @state = :ok
    @speed = 0

    super(map.scene, sprite, position)

    @sounds = {}
    [:chased, :squashed].each do |sound|
      @sounds[sound] = sound sound_path "rat_#{sound}.ogg"
    end
    @sounds.each_value {|s| s.volume = 30 * (scene.user_data.effects_volume / 50.0)}

    @shadow.scale *= [0.7, 0.3]
  end

  def collide?(other)
    other.z <= 4 and super(other)
  end

  def update
    scene.players.shuffle.each do |player|
      if player.ok? and collide? player and @state == :ok
        if player.velocity_z < 0
          @sprite.sheet_pos = SQUASHED_SPRITE
          scene.timer.increase SQUASHED_EXTRA_TIME
          player.score += SQUASHED_SCORE
          @state = :squashed
          @sprite.y += 3
          @sprite.scale_x *= -1 if rand() < 0.5
          @sounds[:squashed].play
          FloatIcon.new(:extra_time, player)
          scene.create_particle([x, y, z + 0.5], velocity: [0, 0, 48], number: 16,
              random_velocity: [16, 16, 16], color: Color.red)

        else
          @sprite.sheet_pos = CHASED_SPRITE
          player.score += TOUCHED_SCORE
          @state = :chased
          @sounds[:chased].play
          @speed = RUN_SPEED
        end

        break
      end
    end

    case @state
      when :ok
         @sprite.sheet_pos = [(scene.timer.elapsed * 2.0).floor % 2, 0]
      when :chased
        self.x += @speed * frame_time
        @sprite.sheet_pos = [3 + (scene.timer.elapsed * 2.0).floor % 2, 0]
    end

    super
  end
end
