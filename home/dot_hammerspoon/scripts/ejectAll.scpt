-- Eject all disks
-- Kudos: http://apple.stackexchange.com/a/143427/104604
tell application "Finder" to eject (every disk whose ejectable is true and local volume is true and free space is not equal to 0)
