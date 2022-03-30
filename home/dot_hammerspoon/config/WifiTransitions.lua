-- Configuration for WifiTransitions.spoon

if not spoon.WiFiTransitions then
  return
end

-- Act on transitions to nil netorks
spoon.WiFiTransitions.actOnNilTransitions = true

spoon.WiFiTransitions.actions = {
  { -- Notify me on changes
    fn = function(_, _, prev_ssid, new_ssid)
      if new_ssid then
        hs.notify.new({ title="Wifi: " .. new_ssid, autoWithdraw=True }):send()
      else
        hs.notify.new({ title="Wifi Disconnected", autoWithdraw=True }):send()
      end
    end
  }
}

spoon.WiFiTransitions:start()
