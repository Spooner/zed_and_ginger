class OptionsControls < GuiScene
  LABEL_COLOR = Color.new(200, 200, 200)

  LINE_SPACING = 0.3
  HEADING_SIZE = 6
  SUB_HEADING_SIZE = 4.5
  ITEM_SIZE = 4

  TITLE_X = 4
  LABEL_X = 6
  BUTTON_X = 35

  def setup
    super()

    y = 0

    gui_controls << ShadowText.new("Controls", at: [TITLE_X, y], size: HEADING_SIZE)
    y += gui_controls.last.height + LINE_SPACING

    y = sub_heading(y, "General")

    UserData::VALID_CONTROLS.each do |control|
      control_name = control.to_s.tr('_', ' ').capitalize
      gui_controls << ShadowText.new(control_name, at: [LABEL_X, y], size: ITEM_SIZE, color: LABEL_COLOR)
      current = user_data.control(control)
      gui_controls << Button.new(display_for_key(current), at: [BUTTON_X, y], size: ITEM_SIZE, shortcut: nil) do
        run_scene :enter_control, self, "Press key to: #{control_name}", current do |new_value|
          if new_value
            user_data.set_control(control, new_value)
            pop_scene
            push_scene name
          end
        end
      end

      y += gui_controls.last.height + LINE_SPACING
    end

    Player::NAMES.each_with_index do |player_name|
      player_display_name = player_name.to_s.capitalize
      y = sub_heading(y, player_display_name)

      UserData::VALID_PLAYER_CONTROLS.each do |control|
        gui_controls << ShadowText.new(control.to_s.capitalize, at: [LABEL_X, y], size: ITEM_SIZE, color: LABEL_COLOR)
        current = user_data.player_control(player_name, control)
        gui_controls << Button.new(display_for_key(current),
                                   at: [BUTTON_X, y], size: ITEM_SIZE, shortcut: nil) do
          run_scene :enter_control, self, "Press #{control} for #{player_display_name}", current do |new_value|
            if new_value
              user_data.set_player_control(player_name, control, new_value)
              pop_scene
              push_scene name
            end
          end
        end

        y += gui_controls.last.height + LINE_SPACING
      end
    end

    y += LINE_SPACING * 2
    gui_controls << Button.new("Back", at: [TITLE_X, y], size: SUB_HEADING_SIZE) do
      pop_scene
    end
  end

  def sub_heading(y, text)
    sub_heading = ShadowText.new(text, at: [LABEL_X, y], size: SUB_HEADING_SIZE)

    # Create a semi-transparent background behind the sub-title.
    rect = sub_heading.rect
    rect.x -= LABEL_X - TITLE_X
    rect.width = (GAME_RESOLUTION.width - rect.x * 2) * 0.7
    gui_controls << Polygon.rectangle(rect)
    gui_controls.last.color = Color.new(255, 255, 255, 50)

    gui_controls << sub_heading
    y += gui_controls.last.height + LINE_SPACING
    y
  end

  def register
    super

    on :key_press, key(:escape) do
      pop_scene
    end
  end

  def render(win)
    background.draw_on win
    super
  end
end
