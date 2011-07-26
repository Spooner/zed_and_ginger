require_relative "dialog_scene"

class GameOver < DialogScene
  TEXT_SIZE = 6
  BUTTON_Y = 10

  def setup(previous_state, next_unlocked)
    super(previous_state)

    gui_controls << Polygon.rectangle([17, BUTTON_Y - 1, 66, TEXT_SIZE + 2], Color.new(0, 0, 0, 200))

    gui_controls << Button.new("Menu   ", self, at: [20, BUTTON_Y], size: TEXT_SIZE) do
      pop_scene :menu
    end

    gui_controls << Button.new("Restart", self, at: [40, BUTTON_Y], size: TEXT_SIZE) do
      pop_scene :restart
    end

    if next_unlocked
      gui_controls << Button.new("Next   ", self, at: [60, BUTTON_Y], size: TEXT_SIZE) do
        pop_scene :next
      end
    else
      gui_controls << Text.new("[Next   ]", at: [60, BUTTON_Y], size: TEXT_SIZE, color: PickLevel::DISABLED_COLOR)
    end
  end
end
