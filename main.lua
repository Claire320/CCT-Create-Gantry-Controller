local motor = peripheral.wrap("back")


local gridMultX = 9
local gridMultZ = 5


function resetOutputs()
  redstone.setOutput("left",false)
  redstone.setOutput("right",false)
end

function waitTilFinished()
  repeat sleep(0.1) until not motor.isRunning()
  sleep(1)
end


function moveX(movement,direction)
  resetOutputs()
  sleep(.5)
  motor.move(movement,direction)
  waitTilFinished()
end

function moveZ(movement,direction)
  resetOutputs()
  redstone.setOutput("left",true)
  sleep(.5)
  motor.move(movement,-direction)
  waitTilFinished()
end

function moveY(movement,direction)
  resetOutputs()
  redstone.setOutput("left",true)
  redstone.setOutput("right",true)
  sleep(.5)
  motor.move(movement,direction)
  waitTilFinished()
end


function resetGantry()
  
  moveY(12,-1)

  while not redstone.getInput("bottom") do
    moveX(3,-1)
    moveZ(3,-1)
  end

  print("reset")

end


function moveToPoint(x,y,z)
  resetGantry()

  moveX(x,1)
  moveZ(z,1)
  moveY(y,1)

end


moveToPoint(0*gridMultX,0,0*gridMultZ)
