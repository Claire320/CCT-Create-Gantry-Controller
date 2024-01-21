local motor = peripheral.wrap("back")

function resetOutputs()
  redstone.setOutput("left",false)
  redstone.setOutput("right",false)
end

function moveX(movement,direction)
  resetOutputs()

  motor.move(movement,direction)
end

function moveZ(movement,direction)
  resetOutputs()
  redstone.setOutput("left",true)

  motor.move(movement,direction)
end

function moveY(movement,direction)
  resetOutputs()
  redstone.setOutput("left",true)
  redstone.setOutput("right",true)

  motor.move(movement,direction)
end
