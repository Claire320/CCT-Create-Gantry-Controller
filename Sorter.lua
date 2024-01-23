local modem = peripheral.find("modem") or error("No modem attached", 0)


function sortCrate(zCoord)
  modem.transmit(20, 1, "SortAt-"..tostring(zCoord))
end


while true do

  if disk.isPresent("left") then
    local label = disk.getLabel("left")
    if label == "Cobblestone" then
      sortCrate(1)
    elseif label == "Logs" then
      sortCrate(2)
    elseif label == "Bricks" then
      sortCrate(3)
    elseif label == "Diamond" then
      sortCrate(4)
    elseif label == "Redstone" then
      sortCrate(5)
    end
    sleep(5)
  end

  sleep(.1)
end
