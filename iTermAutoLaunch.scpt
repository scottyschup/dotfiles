on delay duration
  set endTime to (current date) + duration
  repeat while (current date) is less than endTime
    tell AppleScript to delay endTime - (current date)
  end repeat
end delay

tell application "iTerm"
  tell first terminal
    tell application "System Events"
      key code 124 using {shift down, command down, control down}
    end
    delay 2

    tell first session
      set name to "Console Panes"
      write text "node"
    end tell
    tell second session
      write text "z lumberyard; r c"
      set name to "Console Panes"
    end tell

    launch session "Default Session"

    tell application "System Events"
      key code 125 using {shift down, command down, control down}
    end
    tell application "System Events"
      key code 125 using {shift down, command down, control down}
    end
    delay 2

    launch session "Default Session"
    delay 1


    tell third session
      write text "z woodshop; grunt serve"
    end tell
    tell fourth session
      write text "z lumberyard; r s"
    end tell
    tell fifth session
      write text "redis-cli shutdown; redis-server"
    end tell
    tell sixth session
      write text "zl analytics"
    end tell
  end tell
end tell
