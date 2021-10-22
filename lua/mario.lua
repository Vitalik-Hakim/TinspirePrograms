platform.window:setBackgroundColor(0x7ad6fd)

cursor.hide()

-- document.markChanged()

deviceID = platform.getDeviceID()

tStep = 0.05
height = platform.window:height() 
width = platform.window:width()

px = 0 -- set elsewhere
py = 0

sx = 0
sy = 0

x = 0
y = 0 -- cartesian coordinate system, quadrant I

fallAcc = 80 -- in px per sec
vy = 0
vx = 0 -- px moved per tStep

justHit = 0

map = {x=50, y=150, node=1}
popup = nil

lives = 5 -- should be like 5

powers = {
    big = false
}

groundElements = {
    {
        {x=0, sx=450}, {x=500, sx=750}, {x=0, sx=0}
    }, 
    {
        {x=0, sx=200}, {x=271, sx=292}, {x=620, sx=292}, {x=912, sx=308}, {x=1273, sx=189}
    }, 
    {   
        {x=0, sx=200}, {x=0, sx=200}, {x=200, sx=403}, {x=673, sx=676}, {x=1395, sx=393}
    }, 
    {
        {x=0, sx=200}
    },
    {
        {x=0, sx=200}
    }
}

blockElements = {
    {
        {x=200, y=0, sx=25, sy=35}, {x=330, y=0, sx=25, sy=55}, {x=595, y=0, sx=25, sy=45},
        {x=750, y=0, sx=25, sy=55}
    }, 
    {
        {x=406, y=0, sx=22, sy=36}, {x=470, y=0, sx=25, sy=56}, {x=620, y=0, sx=16, sy=41}, 
        {x=744, y=0, sx=25, sy=13}, {x=838, y=0, sx=19, sy=39}, {x=927, y=0, sx=17, sy=39},
        {x=980, y=0, sx=18, sy=40}, {x=944, y=0, sx=36, sy=21}, {x=1157, y=0, sx=17, sy=15}
    }, 
    {
        {x=214, y=0, sx=18, sy=34}, {x=310, y=0, sx=11, sy=11}, {x=524, y=0, sx=22, sy=46},
        {x=450, y=0, sx=23, sy=23}, {x=745, y=0, sx=13, sy=25}, {x=745, y=25, sx=64, sy=11},
        {x=910, y=0, sx=16, sy=33}, {x=1027, y=0, sx=20, sy=54}, {x=1084, y=0, sx=25, sy=87},
        {x=1145, y=0, sx=25, sy=102}, {x=1330, y=0, sx=14, sy=14}, {x=1400, y=0, sx=14, sy=13},
        {x=1480, y=0, sx=13, sy=13}
    }, 
    {},
    {}
}

stdblock = {
    {{x=84, y=60}, {x=116, y=60}},
    {},
    {},
    {},
    {}
}

enemies = {} -- set elsewhere

clouds = {
    {
        {x=150, y=145}, {x=190, y=140}, {x=550, y=140}, {x=565, y=145}, {x=670, y=150},
        {x=850, y=155}, {x=865, y=145}
    }, 
    {
        {x=85, y=144}, {x=120, y=140}, {x=370, y=140}, {x=755, y=140}, {x=780, y=147}, 
        {x=1061, y=143}, {x=1102, y=140}, {x=1385, y=140}, {x=1337, y=147}
    }, 
    {
        {x=60, y=140}, {x=94, y=146}, {x=296, y=140}, {x=581, y=140}, {x=599, y=131},
        {x=850, y=137}, {x=888, y=142}, {x=1250, y=140}, {x=1560, y=140}, {x=1585, y=132}
    }, 
    {},
    {}
}

bushes = {
    {
        {x=100, sy=30}, {x=220, sy=50}, {x=400, sy=30}, {x=560, sy=50}, {x=650, sy=30},
        {x=750, sy=50}, {x=895, sy=30}, {x=950, sy=50}
    }, 
    {
        {x=152, sy=34}, {x=370, sy=34}, {x=500, sy=31}, {x=714, sy=43},
        {x=793, sy=29}, {x=1299, sy=38}, {x=1331, sy=28}, {x=1099, sy=40}, 
        {x=993, sy=32}
    }, 
    {
        {x=1468, sy=43}, {x=1500, sy=31}, {x=1179, sy=40}, {x=1284, sy=24}, {x=1010, sy=42},
        {x=979, sy=29}, {x=681, sy=40}, {x=530, sy=43}, {x=370, sy=40}, {x=336, sy=27},
        {x=40, sy=40}, {x=1670, sy=40}
    }, 
    {

    },
    {
    
    }
}

flag = {
    {x=900, y=0, sx=3, sy=90},
    {x=1377, y=0, sx=3, sy=90},
    {x=1550, y=0, sx=3, sy=90},
    {x=-100, y=0, sx=3, sy=90},
    {x=-100, y=0, sx=3, sy=90}
    }

spikes = {
    {{x=450, y=-62, sx=47}},
    {},
    {{x=1109, y=0, sx=36}},
    {},
    {{x=100, y=0, sx=100}}
}

question = {} -- set elsewhere

gameOver = false
victory = false
onGround = true
dying = false
time = 100

inMap = false
inMenu = false
menuBox = 1


image_question = image.new(_R.IMG.questionBoxRightSize)

createMode = {active=false, move=true, phase="free", ref=nil, type=nil}

mapLocations = {{x=46, y=146}, {x=106, y=146}, {x=206, y=146}, {x=206, y=96}, {x=266, y=96}} -- these must always be even

function setVars()
    question = {
        {{x=100, y=60, pow='big'}}, -- 16 by 16 box
        {{x=474, y=99, pow='big'}},
        {{x=773, y=98, pow='big'}},
        {},
        {}
    }

    for i, qE in ipairs(question[map.node]) do 
        table.insert(blockElements[map.node], {x=qE.x, y=qE.y, sx=16, sy=16})
    end

    for i, sE in ipairs(stdblock[map.node]) do 
        table.insert(blockElements[map.node], {x=sE.x, y=sE.y, sx=16, sy=16})
    end

    enemies = {
        {
            {x=250, y=0, sx=10, sy=10, vx=-2, vy=0}, {x=570, y=0, sx=10, sy=10, vx=-2, vy=0},
            {x=620, y=0, sx=10, sy=10, vx=-2, vy=0}, {x=700, y=0, sx=10, sy=10, vx=-5, vy=0}
        }, 
        {
            {x=229, y=-220, sx=10, sy=10, vx=-3, vy=-40}, {x=447, y=0, sx=18, sy=10, vx=-3, vy=-0}, 
            {x=228, y=-220, sx=10, sy=10, vx=-3, vy=-40}, {x=644, y=0, sx=17, sy=10, vx=-3, vy=-0}, 
            {x=888, y=0, sx=10, sy=10, vx=-3, vy=0}, {x=981, y=40, sx=10, sy=10, vx=-3, vy=0}, 
            {x=1005, y=0, sx=27, sy=10, vx=-3, vy=0}, {x=1345, y=0, sx=10, sy=10, vx=-3, vy=0}, 
            {x=1085, y=0, sx=10, sy=10, vx=-3, vy=0}
        }, 
        {
            {x=145, y=0, sx=17, sy=10, vx=-3, vy=-0}, {x=272, y=0, sx=10, sy=10, vx=3, vy=-0},
            {x=490, y=0, sx=10, sy=23, vx=-3, vy=0}, {x=360, y=0, sx=24, sy=10, vx=-3, vy=0},
            {x=777, y=0, sx=10, sy=18, vx=-3, vy=0}, {x=750, y=36, sx=10, sy=10, vx=-3, vy=0},
            {x=990, y=0, sx=10, sy=10, vx=-3, vy=0}, {x=1440, y=0, sx=10, sy=27, vx=-3, vy=0}
        }, 
        {

        },
        {
        
        }
    }
    px = 50
    py = 149
    sx = 10
    if (powers.big) then
        sy = 16
    else
        sy = 10
    end
    x = 0
    y = 0
    vy = 0
    vx = 0

    justHit = 0

    gameOver = false
    victory = false
    onGround = true
    dying = false

    time = 100
end

wait = 0

setVars()

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

mapLocations.length = tablelength(mapLocations)

function MoveAllowed(lvx, lvy, lx, ly, lsx, lsy, lpx, lpy)
    if (lx == nil) then
        lx = x
        ly = y
        lsx = sx
        lsy = sy
        lpx = px
        lpy = py
    end
    -- if vx > 0, then check right, if vx < 0, then check left
    for i, gE in ipairs(groundElements[map.node]) do
        if (ly + lvy < 0) then
            --x + px + sx >= gE.x and x + px <= gE.x + gE.sx) then
            if (lx + lvx + lpx + lsx >= gE.x and lx + lpx + lvx < gE.x + gE.sx) then
                return false
            end
        end
    end
    
    for i, bE in ipairs(blockElements[map.node]) do
        if (ly + lvy < bE.y + bE.sy and ly + lsy + lvy > bE.y) then
            --x + px + sx >= gE.x and x + px <= gE.x + gE.sx) then
            if (lx + lvx + lpx + lsx >= bE.x and lx + lpx + lvx < bE.x + bE.sx) then
                return false
            end
        end
    end
    
    if (x + px + vx < 0) then
        return false
    end
    
    return true
end

function activateQuestion(q)
    if (q.pow == 'big') then
        powers.big = true
        
        y = y - (16 - sy)
        sy = 16
    end
end

function checkQuestion()
    for i, qE in ipairs(question[map.node]) do
        if (qE.y < y + vy) then
        end
        if (qE.y > y + vy and vy > 0) then
            if (x + px + sx > qE.x and x + px < qE.x + 16) then
                qE.animation = 4
                activateQuestion(qE)
                return true
            end
        end
    end
end

function checkBounceOnEnemy(e)
    -- step back in time
    tmp_x = x - vx
    tmp_y = y - vy
    
    -- check if player above enemy and check if player is moving downwards
    if (tmp_y > e.y + e.sy and vy < 0) then
        -- check if the player is right above the enemy
        if (tmp_x + px + sx > e.x and tmp_x + px < e.x + e.sx) then
            return true
        end
    end
    return false
end


function contactWithEnemy()
    for i, e in ipairs(enemies[map.node]) do
        if (y < e.y + e.sy and y + sy > e.y) then
            if (x + px + sx > e.x and x + px < e.x + e.sx) then

                if (e.dying ~= nil) then -- so that a dying enemy doesn't kill the player
                    return false
                end

                -- check if the player bounces of enemy head or dies

                if (checkBounceOnEnemy(e)) then
                    -- kill enemy
                    e.dying = true
                    return false
                else
                    return true
                end
            end
        end
    end

    for i, s in ipairs(spikes[map.node]) do
        if (y < s.y + 10 and y + sy > s.y) then
            if (x + px + sx > s.x and x + px < s.x + s.sx) then
                return true
            end
        end
    end

    return false
end

function contactWithFlag()
    f = flag[map.node]
    if (y + sy > f.y and y < f.y + f.sy) then
        if (x + px + sx > f.x and x + px < f.x + f.sx) then
            return true
        end
    end
    return false
end

function on.paint(gc)
    if (inMap) then
        gc:setColorRGB(0, 247, 44)
        gc:fillRect(0, 0, width, height)
        -- map
        gc:setColorRGB(0, 0, 255)
        gc:fillPolygon({160, height, 172, height, 172, 135, 150, 115, 0, 115, 0, 127, 148, 127, 160, 137})

        gc:setColorRGB(63, 105, 30) -- bushes
        gc:fillArc(56, 134, 20, 12, 0, 180)
        gc:fillArc(106, 100, 20, 12, 0, 180)
        gc:fillArc(116, 100-3, 20, 18, 0, 180)

        gc:setColorRGB(255, 255, 255)
        for i, mL in ipairs(mapLocations) do
            --if (i > maxLevel) then gc:setColorRGB(255, 0, 0) end
            gc:fillRect(mL.x, mL.y, 19, 19)
        end

        gc:setColorRGB(120, 87, 0)
        gc:fillRect(mapLocations[1].x + 19, mapLocations[1].y + 4, mapLocations[2].x - (mapLocations[1].x+19), 11)
        gc:fillRect(mapLocations[2].x + 19, mapLocations[2].y + 4, mapLocations[3].x - (mapLocations[2].x+19), 11)
        gc:fillRect(mapLocations[3].x + 4, mapLocations[4].y + 19, 11, mapLocations[3].y - (mapLocations[4].y+19))
        gc:fillRect(mapLocations[4].x + 19, mapLocations[4].y + 4, mapLocations[5].x - (mapLocations[4].x + 19), 11)

        -- player
        gc:setColorRGB(0, 0, 255)
        gc:drawRect(map.x, map.y - (sy - 10), sx, sy)

        gc:setColorRGB(0, 0, 0)
        gc:drawString("Mario for the Calculator", 90, 5)

        if (not (popup == nil)) then
            tmp = gc:getStringWidth(popup)
            tmp2 = gc:getStringHeight(popup)
            gc:setColorRGB(255, 255, 255)
            gc:fillRect((width/2) - (tmp/2 + 5), (height/2) - (tmp2/2 + 5), tmp + 10, tmp2 + 10)
            gc:setColorRGB(0, 0, 0)
            gc:drawString(popup, (width/2) - (tmp/2), (height/2) - (tmp2/2))
        end
        return
    end

    -- level drawing system
    
    gc:setColorRGB(255, 255, 255)
    for i, c in ipairs(clouds[map.node]) do
        gc:fillArc(c.x - x, 150 - c.y, 80, 20, 0, 360)
    end
    
    gc:setColorRGB(63, 105, 30)
    for i, b in ipairs(bushes[map.node]) do
        gc:fillArc(b.x - x, 150 - b.sy/2, 40, b.sy, 0, 360)
    end
    
    gc:setColorRGB(0, 247, 44)
    --gc:fillRect(0, 150, 320, 80)
    for i, gE in ipairs(groundElements[map.node]) do
        gc:fillRect(gE.x - x, 150, gE.sx, 80)
    end

    gc:setColorRGB(100, 100, 100)
    for i, sE in ipairs(spikes[map.node]) do -- spikes are 10 tall
        step = math.ceil(sE.sx / 5)
        tmp_x = sE.x
        while (tmp_x < sE.x + sE.sx) do
            gc:fillPolygon(
                {
                    tmp_x - x, 150 - sE.y, 
                    tmp_x + math.floor(step / 2) - x, 150 - (sE.y + 10), 
                    tmp_x + step - x, 150 - sE.y, 
                    tmp_x - x, 150 - sE.y
                })
            tmp_x = tmp_x + step
        end

    end

    gc:setColorRGB(67, 47, 0)
    for i, bE in ipairs(blockElements[map.node]) do
        --print(bE.x - x, bE.y - 150)
        gc:fillRect(bE.x - x, 150 - (bE.y + bE.sy), bE.sx, bE.sy)
    end

    gc:setColorRGB(0, 0, 0)
    for i, bE in ipairs(stdblock[map.node]) do
        tmp = 150 - (bE.y + 16)
        gc:drawRect(bE.x - x, tmp, 8, 4)
        --gc:drawRect(bE.x - x + 8, 150 - (bE.y + 16), 7, 4)

        gc:drawLine(bE.x - x + 8, tmp, bE.x - x + 15, tmp)
        gc:drawLine(bE.x - x + 8, tmp + 4, bE.x - x + 15, tmp + 4)

        gc:drawRect(bE.x - x + 4, tmp + 4, 8, 4)

        gc:drawRect(bE.x - x, tmp + 8, 8, 4)

        gc:drawLine(bE.x - x + 8, tmp + 8, bE.x - x + 15, tmp + 8)
        gc:drawLine(bE.x - x + 8, tmp + 12, bE.x - x + 15, tmp + 12)

        gc:drawLine(bE.x - x + 4, tmp + 12, bE.x - x + 4, tmp + 15)
        gc:drawLine(bE.x - x + 12, tmp + 12, bE.x - x + 12, tmp + 15)

    end

    for i, qE in ipairs(question[map.node]) do        
        --gc:setColorRGB(255, 204, 102)

        --gc:fillRect(qE.x - x, 150 - (qE.y + 16), 16, 16)

        --gc:setColorRGB(0, 0, 0)
        --gc:drawString("?", qE.x - x + 4, 150 - (qE.y + 20))
        
        gc:drawImage(image_question, qE.x - x, 150 - (qE.y + 16))

        if (qE.animation ~= nil) then
            if (qE.animation > 0) then
                qE.y = qE.y + (4 - math.abs(qE.animation))
            elseif (qE.animation < 0) then
                qE.y = qE.y - (4 - math.abs(qE.animation))
            end
            qE.animation = qE.animation - 2
            if (qE.animation < -4) then
                table.remove(question[map.node], i)
            end
        end
        
    end

    f = flag[map.node]
    gc:setColorRGB(40, 40, 40)
    gc:fillRect(f.x - x, 150-f.sy, f.sx, f.sy)
    gc:setColorRGB(0, 0, 0)
    gc:fillRect((f.x + f.sx) - x, 150-f.sy, 30, 20)
    
    for i, e in ipairs(enemies[map.node]) do
        gc:setColorRGB(255, 0, 0)
        gc:drawRect(e.x - x, 149 -(e.y + e.sy), e.sx, e.sy) -- im retarded 
    end
    
    gc:setColorRGB(0, 0, 255)
    gc:drawRect(px, py-(y + sy), sx, sy)

    gc:setColorRGB(0, 0, 0)

    if (gameOver) then
        if (lives >= 0) then
            gc:drawString("You Died", 115, 50)
        else
            gc:drawString("Game Over", 110, 50)
        end
    end
    if (victory) then
        gc:drawString("Level Complete", 100, 30)
    end
    
    gc:drawString(math.floor(time), 5, 0)
    gc:drawString(x + px, 5, 20)
    if (lives < 0) then
        gc:drawString(0, 300, 0)
    else
        gc:drawString(lives, 300, 0)
    end

    if (inMenu) then
        gc:setColorRGB(255, 255, 255)
        gc:fillRect((width - 110) / 2, (height - 60) / 2, 110, 60)

        gc:setColorRGB(255, 253, 56)
        if (menuBox == 1) then
            gc:fillRect((width - 110) / 2, (height - 60) / 2 + 21, 110, 20)
        elseif (menuBox == 2) then
            gc:fillRect((width - 110) / 2, (height - 60) / 2 + 41, 110, 20)
        end

        gc:setColorRGB(0, 0, 0)
        gc:drawRect((width - 110) / 2, (height - 60) / 2, 110, 60)

        gc:drawString("Menu", (width - 110) / 2 + 35, (height - 60) / 2)
        gc:drawString("Return to Map", (width - 110) / 2 + 5, (height - 60) / 2 + 20)
        gc:drawString("Return to Level", (width - 110) / 2 + 5, (height - 60) / 2 + 40)
    end

    if (createMode.active) then
        gc:setColorRGB(0, 0, 0)
        gc:drawString(createMode.phase, 50, 0)
    end
    gc:drawString(tablelength(question[map.node]), 50, 0) -- for debugging
end

function on.timer()

    -- menu mechanics

    if (inMenu) then
        platform.window:invalidate()
        return
    end

    -- map mechanics

    if (inMap) then
        if (not (map.x == mapLocations[map.node].x + 4 and map.y == mapLocations[map.node].y + 4)) then
            if (mapLocations[map.node].x + 4 > map.x) then map.x = map.x + 4
            elseif (mapLocations[map.node].x + 4 < map.x) then map.x = map.x - 4 end

            if (math.abs(mapLocations[map.node].x - map.x) < 4) then
                map.x = mapLocations[map.node].x
            end

            if (mapLocations[map.node].y + 4 > map.y) then map.y = map.y + 4
            elseif (mapLocations[map.node].y + 4 < map.y) then map.y = map.y - 4 end

            if (math.abs(mapLocations[map.node].y - map.y) < 4) then
                map.y = mapLocations[map.node].y
            end
        end

        platform.window:invalidate()
        return
    end

    -- createMode mechanics

    if (createMode.active) then
        x = x + vx
        y = 0

        platform.window:invalidate()
        return
    end

    -- start of game mechancis

    if (y < -150 and gameOver == false) then
        gameOver = true
        lives = lives - 1
    elseif (victory == false) then
        time = time - tStep
    end

    if (gameOver or victory) then
        wait = wait + tStep
        if (wait > 3) then
            wait = 0
            if (lives < 0 or victory) then
                --if (maxLevel <= map.node) then
                --    maxLevel = map.node + 1
                --    document.markChanged()
                --end
                inMap = true
            end
            setVars()
        end
    end

    if (victory) then
        vx = 0
        vy = 0
        platform.window:invalidate()
        return
    end

    if (justHit > 0) then
        justHit = justHit - 1
    end

    if (contactWithEnemy() and not dying and justHit == 0) then
        if (powers.big) then
            powers.big = false -- loses big power
            sy = 10
            justHit = 10
        else
            time = 0 -- next block deals with it
        end
    end


    if (time <= 0) then
        if (not dying) then
            vy = vy + 10
            dying = true
            vx = 0
        end
        time = 0
    end

    if (contactWithFlag()) then
        victory = true
    end

    onGround = not MoveAllowed(0, -5)
    
    if (dying) then
        onGround = false
    end
    
    if (MoveAllowed(0, -1) or dying) then
        vy = vy - fallAcc * tStep 
    end

    checkQuestion()
    
    -- ======= MOVE PLAYER =======

    c = 0
    while (not MoveAllowed(0, vy) and not dying) do
        vy = vy / 2
        if (vy < 0) then
            vy = math.ceil(vy)
        elseif (vy > 0) then
            vy = math.floor(vy)
        end
        c = c + 1
        if (c > 5) then
            vy = 0
            break
        end
    end
    y = y + vy -- move player
    
    c = 0
    while (not MoveAllowed(vx, 0)) do
        vx = vx / 2
        if (vx < 0) then
            vx = math.ceil(vx)
        elseif (vx > 0) then
            vx = math.floor(vx)
        end
        c = c + 1
        if (c > 5) then
            vx = 0
            break
        end
    end
    if (x + px < 140) then
        x = 0
        px = px + vx
    else
        x = x + vx
    end
    -- =============================== MOVE ENEMIES ===========================
    for i, e in ipairs(enemies[map.node]) do
        if (e.y < -200 or not e.dead == nil) then
            e.dead = true
        elseif (math.abs(e.x - (x + px)) > 300) then
            -- pass
        else
            if (MoveAllowed(0, 1, e.x, e.y, e.sx, e.sy, 0, 149) or e.dying ~= nil) then
                e.vy = e.vy - fallAcc * tStep
            end                

            if (e.dying == nil) then
                c = 0
                while (not MoveAllowed(0, e.vy, e.x, e.y, e.sx, e.sy, 0, 149)) do
                    e.vy = e.vy / 2
                    if (e.vy < 0) then
                        e.vy = math.ceil(e.vy)
                    elseif (e.vy > 0) then
                        e.vy = math.floor(e.vy)
                    end
                    c = c + 1
                    if (c > 5) then
                        e.vy = 0
                        break
                    end
                end
            end

            e.y = e.y + e.vy

            if (e.dying == nil) then
                c = 0
                flip = false
                tmpx = e.vx
                while (not MoveAllowed(tmpx, 0, e.x, e.y, e.sx, e.sy, 0, 149)) do
                    flip = true
                    tmpx = tmpx / 2
                    if (tmpx < 0) then
                        tmpx = math.ceil(tmpx)
                    elseif (tmpx > 0) then
                        tmpx = math.floor(tmpx)
                    end
                    c = c + 1
                    if (c > 5) then
                        tmpx = 0
                        break
                    end
                end

                if (flip) then
                    e.vx = -e.vx
                end

                e.x = e.x + tmpx
            end
        end
    end
        
    platform.window:invalidate()
end

-- key events
function on.arrowRight()
    if (createMode.active) then
        if (createMode.phase == "free") then vx = 10
        elseif (createMode.phase == "move") then
            if (not (createMode.ref.x == nil)) then
                createMode.ref.x = createMode.ref.x + 1
            end
        elseif (createMode.phase == "size") then
            if (not (createMode.ref.sx == nil)) then
                createMode.ref.sx = createMode.ref.sx + 1
            end
        end
        return
    end

    if (inMap and (map.node == 1 or map.node == 2 or map.node == 4)) then
        map.node = map.node + 1
        return
    end
    if (gameOver or victory) then
        return
    end
    if (vx < 0) then
        vx = 0
    else
        vx = 10 -- speed = 10
    end
end

function on.arrowLeft()
    if (createMode.active) then
        if (createMode.phase == "free") then vx = -10
        elseif (createMode.phase == "move") then
            if (not (createMode.ref.x == nil)) then
                createMode.ref.x = createMode.ref.x - 1
            end
        elseif (createMode.phase == "size") then
            if (not (createMode.ref.sx == nil)) then
                createMode.ref.sx = createMode.ref.sx - 1
            end
        end
        return
    end

    if (inMap and (map.node == 2 or map.node == 3 or map.node == 5)) then
        map.node = map.node - 1
        return
    end
    if (gameOver or victory) then
        return
    end
    if (vx > 0) then
        vx = 0
    else
        vx = -10
    end
end

function on.arrowUp()
    if (createMode.active) then
        if (createMode.phase == "move") then
            if (not (createMode.ref.y == nil)) then
                createMode.ref.y = createMode.ref.y + 1
            end
        elseif (createMode.phase == "size") then
            if (not (createMode.ref.sy == nil)) then
                createMode.ref.sy = createMode.ref.sy + 1
            end
        end
        return
    end

    if (inMap and (map.node == 3)) then
        map.node = map.node + 1
        return
    end
    if (inMenu and menuBox == 2) then
        menuBox = 1
        return
    end
    if (gameOver or victory) then
        return
    end
    if (onGround) then
        y = y + math.floor(25 * tStep) -- insta jump
        vy = vy + 25
    end
end

function on.arrowDown()
    if (createMode.active) then
        if (createMode.phase == "free") then vx = 0
        elseif (createMode.phase == "move") then
            if (not (createMode.ref.y == nil)) then
                createMode.ref.y = createMode.ref.y - 1
            end
        elseif (createMode.phase == "size") then
            if (not (createMode.ref.sy == nil)) then
                createMode.ref.sy = createMode.ref.sy - 1
            end
        end
        return
    end

    if (inMap and (map.node == 4)) then
        map.node = map.node - 1
        return
    end
    if (inMenu and menuBox == 1) then
        menuBox = 2
        return
    end
    if (gameOver or victory) then
        return
    end
    vx = 0
end

function on.mouseDown(x, y)
    if (inMenu) then
        if (menuBox == 1) then
            inMap = true
            inMenu = false
        elseif (menuBox == 2) then
            inMenu = false
        end
        return
    end

    if (inMap) then
        if not (popup == nil) then
            popup = nil
            return
        end
        --print(maxLevel)
        -- player level number map.node
        --if (map.node > maxLevel) then
        --    popup = "Level Not Unlocked Yet"
        --   
        --    return
        --end

        -- start up level
        inMap = false
        lives = 5
        setVars()
        return
    end
end

function on.contextMenu()
    menuBox = 1
    inMenu = true
end

function on.escapeKey()
    inMenu = false
end

function on.charIn(char) -- debug feature
    if (char == 'm') then
        inMap = true
    elseif (char == 'n') then
        --maxLevel = maxLevel + 1
    elseif (char == 'c') then
        createMode.active = not createMode.active
    elseif (createMode.active and createMode.phase == "free") then
        if (char == 'b') then
            createMode.ref = {x=x+px, y=0, sx=25, sy=25} 
            table.insert(blockElements[map.node], createMode.ref)  
        elseif (char == 'g') then
            createMode.ref = {x=x+px, sx=100}
            table.insert(groundElements[map.node], createMode.ref)
        elseif (char == 'w') then 
            createMode.ref = {x=x+px, y=140}
            table.insert(clouds[map.node], createMode.ref)
        elseif (char == 's') then 
            createMode.ref = {x=x+px, sy=40}
            table.insert(bushes[map.node], createMode.ref)
        elseif (char == 'f') then 
            createMode.ref = {x=x+px, y=0, sx=3, sy=90}
            flag[map.node] = createMode.ref
        elseif (char == 'e') then 
            createMode.ref = {x=x+px, y=0, sx=10, sy=10, vx=-3,vy=0} 
            table.insert(enemies[map.node], createMode.ref) 
        elseif (char == '1') then
            createMode.ref = {x=x+px, y=0, sx=10} -- spikes 
            table.insert(spikes[map.node], createMode.ref)
        elseif (char == '2') then
            createMode.ref = {x=x+px, y=60, pow='big'} -- question 
            table.insert(question[map.node], createMode.ref)
        elseif (char == '3') then
            createMode.ref = {x=x+px, y=0, sx=16, sy=16} -- standard block
            table.insert(blockElements[map.node], createMode.ref) 
        end

        if (char == 'p') then
            -- print all the things
            print("groundElements")
            print('{')
            for i, e in ipairs(groundElements[map.node]) do
                print('{x='..e.x..', sx='..e.sx..'},')
            end
            print('}')

            print("blockElements")
            print('{')
            for i, e in ipairs(blockElements[map.node]) do
                print('{x='..e.x..', y='..e.y..', sx='..e.sx..', sy='..e.sy..'},')
            end
            print('}')

            print("clouds")
            print('{')
            for i, e in ipairs(clouds[map.node]) do
                print('{x='..e.x..', y='..e.y..'},')
            end
            print('}')

            print("bushes")
            print('{')
            for i, e in ipairs(bushes[map.node]) do
                print('{x='..e.x..', sy='..e.sy..'},')
            end
            print('}')

            print("spikes")
            print('{')
            for i, e in ipairs(spikes[map.node]) do
                print('{x='..e.x..', y='..e.y..', sx='..e.sx..'},')
            end
            print('}')

            print("question")
            print('{')
            for i, e in ipairs(question[map.node]) do
                print('{x='..e.x..', y='..e.y..', pow=\''..e.pow..'\'},')
            end
            print('}')

            print("enemies")
            print('{')
            for i, e in ipairs(enemies[map.node]) do
                print('{x='..e.x..', y='..e.y..', sx='..e.sx..', sy='..e.sy..', vx='..e.vx..', vy='..e.vy..'},')
            end
            print('}')
            e = flag[map.node]
            print("flag")
            print('{x='..e.x..', y='..e.y..', sx='..e.sx..', sy='..e.sy..'}')
        else
            createMode.phase = "move"
        end

    elseif (char == '8') then -- up
        on.arrowUp()
    elseif (char == '4') then -- left
        on.arrowLeft()
    elseif (char == '6') then -- right
        on.arrowRight()
    elseif (char == '5') then -- down
        on.arrowDown()
    end
end  

function on.enterKey()
    if (createMode.phase == "move") then createMode.phase = "size"
    elseif (createMode.phase == "size") then createMode.phase = "free" end
end         

timer.start(tStep)
