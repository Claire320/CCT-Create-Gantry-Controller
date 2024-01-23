local station = peripheral.wrap("right")

local trainDocked = false
local trainDockedTime = 0
while true do

  if redstone.getInput("top") then
    if not trainDocked then
      trainDocked = true
      trainDockedTime = os.clock()
    end
    if os.clock()-trainDockedTime >= 2 then
      station.disassemble()
    end
  else
    trainDocked = false
  end

  sleep(0.05)
end
