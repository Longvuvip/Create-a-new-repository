
-- 🛡️ UNIVERSAL ANTIBAN + NOTIFICATION - BY LONGDEPTRAI HUB
if getgenv then getgenv().SecureMode = true end

-- Thông báo trên màn hình
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "🛡️ AntiBan Kích Hoạt",
        Text = "Bạn đã bật chế độ bảo vệ của LongDepTrai Hub!",
        Duration = 5
    })
end)

-- Chặn Kick & Break
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "BreakJoints" then
        warn("[AntiBan] Prevented: " .. tostring(method))
        return nil
    end
    return old(self, ...)
end)

-- Block common logging remotes
local function blockRemote(remoteName)
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, remoteName) then
            v[remoteName] = nil
        end
    end
end

blockRemote("FireServer")
blockRemote("InvokeServer")
blockRemote("ReportAbuse")

print("✅ [LongDepTrai] Universal AntiBan is running.")
