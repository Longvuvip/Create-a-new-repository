-- 🛡️ LongDepTrai - Universal AntiBan MAX Protection (All Games)

if getgenv then getgenv().SecureMode = true end

-- ✅ Chặn Kick & BreakJoints
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "BreakJoints" then
        return nil
    end
    return old(self, ...)
end)

-- 🔐 Chặn Remote log/report
local function nullifyRemoteCalls(remoteNames)
    for _, name in ipairs(remoteNames) do
        for _, obj in pairs(getgc(true)) do
            if typeof(obj) == "table" and rawget(obj, name) then
                obj[name] = function() return nil end
            end
        end
    end
end
nullifyRemoteCalls({"FireServer", "InvokeServer", "ReportAbuse"})

-- 👁️ Fake giá trị đáng nghi (walkspeed, jumppower)
local lp = game:GetService("Players").LocalPlayer
local function protectHumanoid()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if hum.WalkSpeed > 16 then hum.WalkSpeed = 16 end
        end)
        hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
            if hum.JumpPower > 50 then hum.JumpPower = 50 end
        end)
    end
end

protectHumanoid()
lp.CharacterAdded:Connect(function() task.wait(1) protectHumanoid() end)

-- 👀 Ẩn khỏi camera
task.spawn(function()
    local cam = workspace:FindFirstChildWhichIsA("Camera")
    if cam and cam.CameraSubject == lp.Character then
        cam.CameraSubject = nil
    end
end)

print("✅ AntiBan MAX đã kích hoạt")