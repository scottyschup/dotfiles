-- create symlink at ~/Library/Application Support/iTerm/AutoLaunch.scpt
-- I had comments in here originally, but they seemed to affect the running of
-- the script, so I pulled them.
--
-- I don't really use this anymore. Too finicky.
on delay duration
  set endTime to (current date) + duration
  repeat while (current date) is less than endTime
    tell AppleScript to delay endTime - (current date)
  end repeat
end delay

tell application "iTerm"
  tell first terminal
    tell application "System Events"
      -- 123 "left"; 124 "right"; 125 "down"; 126 "up"
      key code 124 using {shift down, command down, control down}
      key code 123 using {control down, command down}
      key code 125 using {shift down, command down, control down}
    end
    delay 2

    tell first session
      write text "z wood; node"
    end tell
    tell second session
      write text "z sawmill; redis-cli"
    end tell
    tell third session
      write text "z lumber; r c"
    end tell

    launch session "Default Session"

    tell application "System Events"
      key code 124 using {shift down, command down, control down}
      key code 123 using {control down, command down}
      key code 125 using {shift down, command down, control down}
    end
    delay 2

    tell fourth session
      write text "z wood; atom .; gls"
    end tell
    tell fifth session
      write text "redis-cli SHUTDOWN; redis-server"
    end tell
    tell sixth session
      write text "z lumber; atom .; omni_killer puma; r s"
    end tell

    launch session "Default Session"
    delay 1
    tell seventh session
      write text "zl analytics"
    end tell
  end tell
end tell
