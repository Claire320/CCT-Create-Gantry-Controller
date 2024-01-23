local modem = peripheral.find("modem") or error("No modem attached", 0)


function split(pString, pPattern)
  local Table = {}
  local fpat = "(.-)" .. pPattern
  local last_end = 1
  local s, e, cap = pString:find(fpat, 1)
  while s do
         if s ~= 1 or cap ~= "" then
        table.insert(Table,cap)
         end
         last_end = e+1
         s, e, cap = pString:find(fpat, last_end)
  end
  if last_end <= #pString then
         cap = pString:sub(last_end)
         table.insert(Table, cap)
  end
  return Table
end


function sortCrate(zCoord)
  modem.transmit(20, 1, "SortAt-"..tostring(zCoord))
end
function deliverCrate(zCoord)
  modem.transmit(20, 1, "Deliver-"..tostring(zCoord))
end


while true do

  if disk.isPresent("left") then
    local label = disk.getLabel("left")

    local splitLabel = split(label,"-")
    local command = splitLabel[1]
    local resource = splitLabel[2]
    local targetFacility = splitLabel[3]

    if command == "Sort" then
      if resource == "Cobble" then
        sortCrate(1)
      elseif resource == "Logs" then
        sortCrate(2)
      elseif resource == "Bricks" then
        sortCrate(3)
      elseif resource == "Diamonds" then
        sortCrate(4)
      elseif resource == "Redstone" then
        sortCrate(5)
      end
      sleep(5)
    elseif command == "Req" then
      if resource == "Cobble" then
        deliverCrate(1)
      elseif resource == "Logs" then
        deliverCrate(2)
      elseif resource == "Bricks" then
        deliverCrate(3)
      elseif resource == "Diamonds" then
        deliverCrate(4)
      elseif resource == "Redstone" then
        deliverCrate(5)
      end
    end
    disk.eject("left")
  end

  sleep(.1)
end
