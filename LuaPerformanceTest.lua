    local print = print
    local math_sqrt = math.sqrt
    local system_getTimer = GetTickCount()		 
    local function test(iterations)		
        local time = 0
        local totalTime = 0
        local testStart = GetTickCount()
     
        for i = 1, iterations do
            local startTime = GetTickCount()
     
            for i = 1, 1000000 do
                --local t = 100 ^ 0.5
                local t = math_sqrt(100)
            end
     
            local testTime = GetTickCount() - startTime
            time = time + testTime
        end
     
        time = time / iterations -- Average the result
        totalTime = GetTickCount() - testStart
     
        local result = "\n\nTest Finished: \n\t" .. iterations * 1000000 .. " calculations\n\t" .. totalTime / 1000 .. " secs taken\n\t" .. time .. " ms on average"
        print(result)
    end
     
    for i = 1, 4 do
        test(50)
    end
