local motor = peripheral.wrap("back")


local DEBUG = true


local GRIDMULTX = 4
local GRIDMULTZ = 8


local currentPosition = {0,0,0}


local stickersEnabled = false


function toggleStickers()
  redstone.setOutput("top",true)
  sleep(0.5)
  redstone.setOutput("top",false)
  sleep(0.5)
  
  stickersEnabled = not stickersEnabled

  if DEBUG then
    print("toggled stickers, state: " .. tostring(stickersEnabled))
  end
end

function resetOutputs()
  redstone.setOutput("left",false)
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

  print(targetX)
  print(currentPosition[1])

  local movement = targetX-currentPosition[1]
  print(movement)
  local movementType = 1
  if movement < 0 then
    movementType = -1
  end

  print(movement)
  print(math.abs(movement))
  print(movementType)

  resetOutputs()
  redstone.setOutput("left",true)
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
  redstone.setOutput("left",true)
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
  redstone.setOutput("left",true)
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
  redstone.setOutput("left",true)
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
    moveY(11,-1)
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

  newMoveY(11)
  
  if not stickersEnabled then
    toggleStickers()
  end
  
  newMoveY(0)

end

function dropContainer()

  if not stickersEnabled then
    toggleStickers()
  end

  newMoveY(11)
  
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

function printCurrentPosition()
  print(currentPosition[1])
  print(currentPosition[2])
  print(currentPosition[3])
end

function moveContainerTo(x1,z1,x2,z2)

  grabContainerAt(x1,z1)
  dropContainerAt(x2,z2)

end


resetGantry()

while true do
  moveContainerTo(2,3,1,2)
  sleep(2)
  moveContainerTo(3,2,2,3)
  sleep(2)
  moveContainerTo(1,2,3,2)
  sleep(2)
end
