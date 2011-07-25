require_relative "game_scene"

# Just like a GameScene, but with a cursor.
class GuiScene < GameScene
  def setup
    super()

    cursor_image = image(image_path("cursor.png"))
    @cursor = sprite cursor_image, scale: [0.5, 0.5], origin: [0, 0]
    @cursor_shown = true
  end

  def register
    super

    on :mouse_left do
      @cursor_shown = false
    end

    on :mouse_entered do
      @cursor_shown = true
    end

    on :mouse_motion do |pos|
      @cursor.pos = pos / window.scaling
    end
  end

  def render(win)
    super
    win.draw @cursor if @cursor_shown
  end
end