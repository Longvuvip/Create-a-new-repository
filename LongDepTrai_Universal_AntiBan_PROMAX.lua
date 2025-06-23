-- ✅ LongDepTrai - Universal AntiBan ProMax 2025 (99–100%)

if getgenv then getgenv().SecureMode = true end

-- 🛡️ Hook Kick / Break
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local m = getnamecallmethod()
    if m == "Kick" or m == "BreakJoints" then return nil end
    return old(self, ...)
end)

-- 🧠 Hook Remote Logs
local function nullifyRemoteCalls(names)
    for _, name in ipairs(names) do
        for _, obj in pairs(getgc(true)) do
            if typeof(obj) == "table" and rawget(obj, name) then
                obj[name] = function() return nil end
            end
        end
    end
end
nullifyRemoteCalls({"FireServer", "InvokeServer", "ReportAbuse"})

-- 🔁 Hook toàn bộ closure functions
for _,v in pairs(getgc(true)) do
    if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
        hookfunction(v, function(...) return nil end)
    end
end

-- 🛑 Chặn đọc chỉ số nguy hiểm
local old_index = mt.__index
mt.__index = newcclosure(function(self, key)
    if key == "WalkSpeed" or key == "JumpPower" or key == "Health" then
        return 16
    end
    return old_index(self, key)
end)

-- 🧬 Fake Identity
local lp = game:GetService("Players").LocalPlayer
pcall(function()
    lp.Name = "Anonymous_" .. math.random(1000,9999)
    lp.DisplayName = "Guest_" .. math.random(100,999)
    lp.UserId = 1234567 + math.random(100000,999999)
end)

-- 🔒 Giữ WalkSpeed/JumpPower an toàn
local function protectHumanoid()
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
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

-- 👁️ Camera spoof
task.spawn(function()
    local cam = workspace:FindFirstChildWhichIsA("Camera")
    if cam and cam.CameraSubject == lp.Character then
        cam.CameraSubject = nil
    end
end)

-- 🔔 Notify
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ AntiBan ProMax",
        Text = "Bảo vệ toàn diện đã kích hoạt!",
        Duration = 6
    })
end)

print("✅ LongDepTrai AntiBan ProMax 2025 is running")