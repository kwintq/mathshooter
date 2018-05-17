
display.setStatusBar(display.HiddenStatusBar)
local cWidth = display.contentCenterX
local cHeight = display.contentCenterY


local physics = require("physics")
physics.start()
physics.setGravity( 0,0)

local enemies = display.newGroup()

-- parametry startowe
local rightValue = null
local gameActive = true
local bagMoveX = 0
local bag 
local speed = 10 
local numseaobject = 0
local seaobjectArray = {}
local onCollision
local score = 0
local multiplication = tostring(math.random(1,9)) .."*".. tostring(math.random(1,9))
local object
local objectActive = math.random(1,4)
local objectCounter = 0

-- funckje globalne
local removeSeaobject
local createGame
local createseaobject
local createbag
local setobjectOn
local next_number
local randomNumber




	-- ustawienie tła
	local background = display.newImage("tlo.jpg")
	background.x = cWidth
	background.y = cHeight
	
	-- ustawienie punktów 
	textBullets = display.newText ("Mnożenie:  "..multiplication, 140, 25, nil, 40)
	textScore = display.newText("Punkty:  "..score, 620, 25, nil, 40)

	-- strzałki poruszania się
	local leftArrow = display.newImage("left.png")
	leftArrow.x = 300
	leftArrow.y = display.contentHeight - 30
	local rightArrow = display.newImage("right.png")
	rightArrow.x = 400
	rightArrow.y =display.contentHeight -30

	
	local function stopbag(event)
		if event.phase == "ended" then
			bagMoveX = 0 
		end
	end
	

	local function movebag(event)
		bag.x = bag.x + bagMoveX
	end
	

	function leftArrowtouch()
		bagMoveX = - speed
	end
	

	function rightArrowtouch()
		bagMoveX = speed
	end
	
	
	local function createWalls(event)	
		if bag.x < 0 then
			bag.x = 0
		end
		if bag.x > display.contentWidth then
			bag.x = display.contentWidth
		end
	end
	
function createbag()
	bag = display.newImage ("bag.png")
	physics.addBody(bag, "static", {density = 1, friction = 0, bounce = 0});
	bag.x = cWidth
	bag.y = display.contentHeight - 140
	bag.myName = "bag"
end


function next_number()
  	local a = math.random(1,9)
  	local b = math.random(1,9)
    local result = tostring(a) .."*".. tostring(b)
    rightValue = a*b
    multiplication = result
end

function falseNumber()
	-- do
		local a = math.random(1, 9)
	    local b = math.random(1, 9)
	    local result = a * b
    -- while (result =! rightValue)
    return result

end


function createseaobject()
	numseaobject = numseaobject +1

	local value = 0
	if numseaobject == objectActive then
		value = rightValue
	else
		value = falseNumber()
	end

	print("numer dla obiektu " ..value)
	print("numer aktywny " ..objectActive)
	if(rightValue)then
		print("prawdziwe " ..rightValue)
	end
			enemies:toFront()
			seaobjectArray[numseaobject]  = display.newImage("seaobject.png")
			physics.addBody ( seaobjectArray[numseaobject] , {density=0.5, friction=0, bounce=0})
			seaobjectArray[numseaobject] .myName = "seaobject" 
			seaobjectArray[numseaobject] .value = value
			--seaobjectArray[numseaobject]  = display.text(value)
			startlocationX = math.random (0, display.contentWidth)
			seaobjectArray[numseaobject] .x = startlocationX
			startlocationY = math.random (-500, -100)
			seaobjectArray[numseaobject] .y = startlocationY
		
			transition.to ( seaobjectArray[numseaobject] , { time = math.random (12000, 20000), x= math.random (0, display.contentWidth ), y=bag.y+500 } )
			enemies:insert(seaobjectArray[numseaobject] )
end



function correctObject()
	return math.random(1,4)
end

function onCollision(event)
	if(event.object1.myName =="bag" and event.object2.myName =="seaobject") then	
			if(event.object2.value == rightValue) then
				score = score + 1
			end
			
			next_number()
			textScore.text = "Punkty:  "..score
			textBullets.text = "Mnożenie:  "..multiplication
			removeSeaobject()
			numseaobject = 0
	end	

end

function removeSeaobject()
	for i =1, #seaobjectArray do
		if (seaobjectArray[i].myName ~= nil) then
		seaobjectArray[i]:removeSelf()
		seaobjectArray[i].myName = nil
		end
	end
end




-- function setobjectOn()
-- 		objectActive = true
-- end

function objectStatus()
	
	if gameActive then
		createseaobject()
	end

	
end

function startGame()
createbag()
next_number()


rightArrow:addEventListener ("touch", rightArrowtouch)
leftArrow:addEventListener("touch", leftArrowtouch)
Runtime:addEventListener("enterFrame", createWalls)
Runtime:addEventListener("enterFrame", movebag)
Runtime:addEventListener("touch", stopbag)
Runtime:addEventListener("collision" , onCollision)

timer.performWithDelay(5000, objectStatus,0)
timer.performWithDelay ( 5000, setobjectOn, 0 )
timer.performWithDelay(300, checkforProgress,0)

end

startGame()
