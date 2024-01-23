local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(20)

local motor = peripheral.wrap("back")
local redstonePort = peripheral.wrap("top")


local DEBUG = true


local GRIDMULTX = 4
local GRIDMULTZ = 8


local currentPosition = {0,0,0}


local stickersEnabled = false


function split(pString, pPattern)
  local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
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


function toggleStickers()
  redstonePort.setOutput("up",true)
  sleep(0.5)
  redstonePort.setOutput("up",false)
  sleep(0.5)

  stickersEnabled = not stickersEnabled

  if DEBUG then
    print("toggled stickers, state: " .. tostring(stickersEnabled))
  end
end

function resetOutputs()
  redstonePort.setOutput("west",false)
  redstone.setOutput("right",false)

  if DEBUG then
    print("reset outputs")
  end
end

function waitTilFinished()
  repeat sleep(0.1) until not motor.isRunning()
  sleep(1)

  if DEBUG then
    print("movement finished")
  end
end


function newMoveX(targetX)

  local movement = targetX-currentPosition[1]
  local movementType = 1
  if movement < 0 then
    movementType = -1
  end

  resetOutputs()
  redstonePort.setOutput("west",true)
  sleep(.5)
  if DEBUG then
    print("moving X")
  end
  motor.move(math.abs(movement),-movementType)
  currentPosition[1] = currentPosition[1]+movement
  waitTilFinished()

end
function newMoveY(targetY)

  local movement = targetY-currentPosition[2]
  local movementType = 1
  if movement < 0 then
    movementType = -1
  end

  resetOutputs()
  redstonePort.setOutput("west",true)
  redstone.setOutput("right",true)
  sleep(.5)
  if DEBUG then
    print("moving Y")
  end
  motor.move(math.abs(movement),movementType)
  currentPosition[2] = currentPosition[2]+movement
  waitTilFinished()

end
function newMoveZ(targetZ)

  local movement = targetZ-currentPosition[3]
  local movementType = 1
  if movement < 0 then
    movementType = -1
  end

  resetOutputs()
  sleep(.5)
  if DEBUG then
    print("moving Z")
  end
  motor.move(math.abs(movement),movementType)
  currentPosition[3] = currentPosition[3]+movement
  waitTilFinished()

end


function moveX(movement,direction)
  resetOutputs()
  redstonePort.setOutput("west",true)
  sleep(.5)
  if DEBUG then
    print("moving X")
  end
  motor.move(movement,-direction)
  currentPosition[1] = currentPosition[1]+(movement*-direction)
  waitTilFinished()
end

function moveZ(movement,direction)
  resetOutputs()
  sleep(.5)
  if DEBUG then
    print("moving Z")
  end
  motor.move(movement,direction)
  currentPosition[3] = currentPosition[3]+(movement*direction)
  waitTilFinished()
end

function moveY(movement,direction)
  resetOutputs()
  redstonePort.setOutput("west",true)
  redstone.setOutput("right",true)
  sleep(.5)
  if DEBUG then
    print("moving Y")
  end
  motor.move(movement,direction)
  currentPosition[2] = currentPosition[2]+(movement*direction)
  waitTilFinished()
end


function resetGantry()

  if not redstone.getInput("bottom") then
    moveY(9,-1)
  end

  while not redstone.getInput("bottom") do
    if not redstone.getInput("bottom") then
      moveX(6,-1)
    end
    if not redstone.getInput("bottom") then
      moveZ(6,-1)
    end
  end

  currentPosition = {0,0,0}

  if DEBUG then
    print("reset gantry")
  end

end


function moveToPoint(x,y,z)

  if DEBUG then
    print("moving to point: (".. tostring(x) .. ", " .. tostring(y) .. ", " .. tostring(z) .. ")")
  end

  newMoveX((x-1)*GRIDMULTX)
  newMoveZ((z-1)*GRIDMULTZ)
  newMoveY(y)

end


function grabContainer()

  if stickersEnabled then
    toggleStickers()
  end

  newMoveY(9)

  if not stickersEnabled then
    toggleStickers()
  end

  newMoveY(0)

end

function dropContainer()

  if not stickersEnabled then
    toggleStickers()
  end

  newMoveY(9)

  if stickersEnabled then
    toggleStickers()
  end

  newMoveY(0)

end


function grabContainerAt(x,z)

  moveToPoint(x,0,z)
  grabContainer()

end

function dropContainerAt(x,z)

  moveToPoint(x,0,z)
  dropContainer()

end

function moveContainerTo(x1,z1,x2,z2)

  grabContainerAt(x1,z1)
  dropContainerAt(x2,z2)

end

function checkSpaceAt(x,z)
  moveToPoint(x,0,z)

  newMoveY(9)

  local scanOutput = false
  if redstonePort.getInput("east") then
    scanOutput = true
  else
    scanOutput = false
  end

  newMoveY(0)

  return scanOutput
end


function printCurrentPosition()
  print(currentPosition[1])
  print(currentPosition[2])
  print(currentPosition[3])
end


resetGantry()

while true do

  if DEBUG then
    print("waiting")
  end

  local event, side, channel, replyChannel, message, distance
  repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
  until channel == 20

  local taskList = split(tostring(message),"-")
  local taskType = taskList[1]
  local args = taskList[2]

  if DEBUG then
    print("Task recieved: "..tostring(message))
    print("Task type: "..taskType)
    print("Task args: "..args)
  end
  if taskType == "SortAt" then
    if tonumber(args) ~= nil then
      currentXIndex = 6
      local availableX = checkSpaceAt(currentXIndex,tonumber(args))
      repeat
        currentXIndex = currentXIndex-1
        availableX = checkSpaceAt(currentXIndex,tonumber(args))
      until availableX or currentXIndex == 1
      if availableX then
        moveContainerTo(9,2,currentXIndex,tonumber(args))
      else
        print("no space available")
      end
    end
  end

end
