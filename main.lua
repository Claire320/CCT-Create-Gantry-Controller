local motor = peripheral.wrap("back")

function moveX(movement,direction)
  redstone.setOutput("left",false)
  redstone.setOutput("right",false)

  motor.move(movement,direction)
end

function moveZ(movement,direction)
  redstone.setOutput("left",true)
  redstone.setOutput("right",false)

  motor.move(movement,direction)
end

function moveY(movement,direction)
  redstone.setOutput("left",true)
  redstone.setOutput("right",true)

  motor.move(movement,direction)
end
