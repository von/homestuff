-- GDocs module
-- Functions to create new Google docs
-- Kudos: https://support.google.com/a/users/answer/9308871?hl=en
local GDocs = {}

-- Set up logger for module
GDocs.log = hs.logger.new("GDocs", "info")

GDocs.newDocURL = "https://doc.new"
GDocs.newSheetURL = "https://sheet.new"
GDocs.newSlidesURL = "https://slides.new"

function GDocs:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

function openURL(url)
  return hs.urlevent.openURL(url)
end

function GDocs.newDoc()
  openURL(GDocs.newDocURL)
end

function GDocs.newSheet()
  openURL(GDocs.newSheetURL)
end

function GDocs.newSlides()
  openURL(GDocs.newSlidesURL)
end

return GDocs
