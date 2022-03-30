-- usb-watcher.lua
-- Alert me on select USB events

local watcher = nil
local lastNotification = nil

local log = hs.logger.new('usb-notifier', 'info')

local ignoredUSBDevices = {
  "",
  "Bluetooth USB Host Controller",
  "BRCM20702 Hub",
  "Internal Memory Card Reader",
  "Apple Internal Keyboard / Trackpad"
}

function usb_callback(t)
  if hs.fnutils.contains(ignoredUSBDevices, t.productName) then
    log.df("Ignoring USB %s product=\"%s\" vendor=\"%s\" vendorId=\"%s\" productId=\"%s\"",
      t.eventType, t.productName, t.vendorName, t.vendorId, t.productId)
    return
  end
  log.f("USB %s product=\"%s\" vendor=\"%s\" vendorId=\"%s\" productId=\"%s\"",
    t.eventType, t.productName, t.vendorName, t.vendorId, t.productId)
  lastNotification = hs.notify.new(
    {title=string.format("USB %s: %s", t.eventType, t.productName), autoWithdraw=True})
  lastNotification:send()
end

local usbwatcher = hs.usb.watcher.new(usb_callback)
usbwatcher:start()
