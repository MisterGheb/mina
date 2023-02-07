-Level 1)
```
function init(robot){
  console.log("Robot initializing...");
}

function loop(robot){
  robot.action = {type: 'move', amount: 40};
}
```

-Level 2)
```
function init(robot) {
	console.log("Robot initializing...");
}

function loop(robot) {
	robot.move(40)
}
```

-Level 3)
```
function init(robot) {
	robot.steps = 0
}

function loop(robot) {
	if(robot.steps%2==0)
		robot.jump(10)
	else
			robot.move(20)
	if(robot.properties.onGround==true)
		robot.steps++
}
```

-Level 4)
```
function init(robot) {
robot.steps = 0
}

function loop(robot) {
	if(robot.steps<3)
		{
		console.log("Step: "+robot.steps)
		if(robot.properties.onGround)
			{
				robot.jump(5)
				robot.steps++
			}
		}
	else if(robot.steps==3)
		{
			if(robot.properties.onGround)
			{
				robot.jump(10)
				robot.steps++
			}
		}
	else
		robot.move(40)
}
```

-Level 5)
```
function init(robot) {
robot.steps = 0
}

function loop(robot) {
	if(robot.steps<3)
		{
		console.log("Step: "+robot.steps)
		if(robot.properties.onGround)
			{
				robot.jump(5)
				robot.steps++
			}
		}
	else if(robot.steps==3 | robot.steps==4)
		{
			if(robot.properties.onGround)
			{
				robot.jump(10)
				robot.steps++
			}
		}
	else
		robot.move(40)
}
```

-Level6)
```
function init(robot) {
}

function loop(robot) {
	robot.move(40);
	robot.action.amount = robot.info().coins % 2 == 1 ? -40: 40
}
```

-Level 7)
```
function init(robot) {
	robot.oldCoins = 0;
	robot.oldEnergy = 100;
}

function loop(robot) {
	robot.move(40);
	if (robot.info().coins > robot.oldCoins ||
		 robot.info().energy > robot.oldEnergy) {
		robot.jump(10);
	}
	robot.oldCoins = robot.info().coins;
	robot.oldEnergy = robot.info().energy;
}
```

-Level 8)
```
function init(robot) {
	robot.iter = 0;
}

function loop(robot) {
	if (robot.iter > 4) {
		robot.jump(10);
	}
	if (robot.info().coins > 0) {
		robot.iter++;
	}
}
```

-Level 9)
```
function init(robot){
    robot.steps=0
}

function loop(robot){
    if (robot.steps < 15) {
      robot.shoot(12);
      robot.steps++;
    } else if (robot.steps < 20) {
        robot.move(40)
        robot.steps++;
    } else if (robot.steps < 25) {
        robot.jump(3);
        robot.steps++;
    } else if (robot.steps < 30) {
        robot.jump(0);
        robot.steps++;
    } else {
        robot.move(40)
    }

  }
```

Level 10:

function init(robot) {
    robot.count = 0;
}
function loop(robot) {
    if (robot.count < 2) {
        robot.action = {type: 'move', amount: 40};
        robot.count++;
    } else {
        robot.action = {type: 'jump', amount: 6};
        robot.count++;
        console.log(robot.count)
    }
}