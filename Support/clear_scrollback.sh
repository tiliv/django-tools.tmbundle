#!/bin/bash

osascript <<-APPLESCRIPT
    delay 0.1
    tell application "System Events"
        tell process "Terminal"
            tell menu bar 1
                tell menu bar item "Edit"
                    tell menu "Edit"
                        click menu item "Clear Scrollback"
                    end tell
                end tell
            end tell
        end tell
    end tell
APPLESCRIPT
