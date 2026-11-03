-- =======================================================
-- SYLPHIN HUB - BREAK AND STEAL AN EGG (FULL ENGINE 2026)
-- UI Source: https://raw.githubusercontent.com/ThienbaoSylphin/Script-Break-And-Steal-An-Egg/refs/heads/main/UI
-- =======================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if game.GameId ~= 10765288803 then
    game:GetService("Players").LocalPlayer:Kick("SylPhin Hub: Script này chỉ dành cho Break and Steal an Egg")
    return
end

local SylPhinBanner = {
    Print = print,
    Started = os.clock(),
    Last = os.clock(),
    Done = 0,
    Total = 4,
}

do
    local ok, renv = pcall(getrenv)
    if ok and type(renv) == "table" and type(renv.print) == "function" then
        SylPhinBanner.Print = renv.print
    end
end

function SylPhinBanner.Show()
    local ok, executor = pcall(identifyexecutor)
    if not ok or type(executor) ~= "string" then executor = "Unknown" end
    local rule = string.rep("=", 58)
    SylPhinBanner.Print(table.concat({
        "",
        [[
  ____  _   _ _     ____  _   _ ___ _   _ 
 / ___|| | | | |   |  _ \| | | |_ _| \ | |
 \___ \| |_| | |   | |_) | |_| || ||  \| |
  ___) |  _  | |___|  __/|  _  || || |\  |
 |____/|_| |_|_____|_|   |_| |_|___|_| \_|
]],
        rule,
        "   SYLPHIN HUB  //  BREAK AND STEAL AN EGG (PREMIUM EDITION)",
        "   Executor: " .. executor .. "   //   Player: " .. game:GetService("Players").LocalPlayer.Name,
        rule,
    }, "\n"))
end

function SylPhinBanner.Step(label)
    local now = os.clock()
    SylPhinBanner.Done = math.min(SylPhinBanner.Done + 1, SylPhinBanner.Total)
    local filled = math.floor(SylPhinBanner.Done / SylPhinBanner.Total * 20 + 0.5)
    SylPhinBanner.Print(string.format("[SylPhin Hub] [%s] %3d%%  %-24s +%dms",
        string.rep("■", filled) .. string.rep(" ", 20 - filled),
        math.floor(SylPhinBanner.Done / SylPhinBanner.Total * 100), label, math.floor((now - SylPhinBanner.Last) * 1000)))
    SylPhinBanner.Last = now
end

function SylPhinBanner.Ready()
    local rule = string.rep("=", 58)
    SylPhinBanner.Print(table.concat({
        rule,
        string.format("   >> SYLPHIN HUB READY in %dms", math.floor((os.clock() - SylPhinBanner.Started) * 1000)),
        rule,
    }, "\n"))
end

pcall(SylPhinBanner.Show)
pcall(SylPhinBanner.Step, "Core Initialization")

if not LPH_OBFUSCATED then
    local function Passthrough(fn) return fn end
    LPH_JIT, LPH_JIT_MAX, LPH_NO_VIRTUALIZE = Passthrough, Passthrough, Passthrough
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local osClock = os.clock
local vector3New, cframeNew = Vector3.new, CFrame.new

local SylPhinCore = setmetatable({}, {
    __newindex = function(self, key, value)
        rawset(self, key, type(value) == "function" and LPH_JIT(value) or value)
    end,
})

SylPhinCore.Config = {
    Discord = "https://discord.gg/F2zUGYejx",
    UpdateLog = {
        { "2026-11-03", "Rebranded to SylPhin Hub & Fully Refactored Performance" },
    },
    UiSource = "https://raw.githubusercontent.com/ThienbaoSylphin/Script-Break-And-Steal-An-Egg/refs/heads/main/UI?t=" .. tostring(os.time()),
    SaveFolder = "SylPhinHub",
    LoadTimeout = 30,
    RequireTimeout = 3,
    MaxFailures = 5,
    FailWindow = 10,
    AlertTries = 20,
    AlertDelay = 0.5,
    TickDelay = 0.25,
    TpSettle = 0.2,
    GrabTimeout = 2,
    CarryGrace = 2.5,
    StandRadius = 6,
    SpeedFallback = 120,
    SkipFor = 4,
    BankTimeout = 2.5,
    HitSlice = 0.8,
    TripCost = 1,
    EggOffset = vector3New(0, 3, 3.5),
    PromptMatch = 30,
    BreakPickupRadius = 40,
    EquipInterval = 5,
    BuyInterval = 1.5,
    ClaimInterval = 60,
    EggInterval = 1,
    EggSpacing = 8,
    SellInterval = 4,
    EspInterval = 0.4,
    BatRange = 15,
    BatGap = 0.72,
    RejoinDelay = 5,
}

SylPhinCore.State = {
    Alive = true,
    Connections = {},
    Requests = {},
    Messages = {},
    Failures = {},
    Halted = {},
    Last = {},
    Status = "Idle",
    Steals = 0,
    Broken = 0,
    Banked = 0,
    StartCash = nil,
    StartAt = osClock(),
    HitTokens = 3,
    HitStamp = osClock(),
    BreakSpot = nil,
    GlobalLockPet = nil,
    IsSequencing = false,
    Opt = {
        AutoSteal = false,
        Take = "Upgrades Only",
        StealRarities = {},
        StealMinValue = 0,
        AutoBreak = false,
        BreakZone = "Best",
        MaxHits = 200,
        RobCarriers = false,
        AutoPlace = false,
        AutoSell = false,
        KeepRarities = {},
        AutoUpgrade = false,
        UpgradeTargets = { Pickaxe = true, Base = true, Trail = true, Treadmill = true },
        AutoBuyPickaxe = false,
        AutoUpgradePlot = false,
        AutoTrail = false,
        AutoTreadmill = false,
        CashReserve = 0,
        BatTarget = nil,
        BatLoop = false,
        BatAura = false,
        EspPickups = false,
        EspEggs = false,
        EspPlayers = false,
        EspMinRarity = "Common",
        SpeedOn = false,
        WalkSpeed = SylPhinCore.Config.SpeedFallback,
        Noclip = false,
        AntiAfk = false,
        AutoRejoin = false,
        AutoTitanicEgg = false,
        PrioritizeTitanicEgg = false,
        AutoSwing = false,
        BreakRarities = {},
        BreakZones = {},
        AutoPlaceEggs = false,
        PlaceRarities = {},
        PlaceAnimals = {},
        AutoHatch = false,
        AutoEquipBest = false,
        AutoUpgradeTreadmill = false,
        AutoUpgradePen = false,
        AutoBuyTrail = false,
        AutoBuyPickaxes = false,
        AutoClaimIndex = false,
        AutoEquipBestBat = false,
        KillAura = false,
        AuraRange = 15,
        AttackDelay = 0.1,
        AntiHit = false,
        AntiRagdoll = false,
        InfJump = false,
        AutoHitCarriers = false,
        EnableSpeed = false,
        SpeedValue = 32,
        Freecam = false,
        FreecamSpeed = 50,
        InstantInteract = false,
        AntiAFK = true,
        NoGameplayPaused = true,
        AutoReconnect = false,
        FPSBoost = false,
        Disable3DRender = false,
        BackgroundTheme = "Black",
        EggESP = false,
        EggESPRarities = {},
        HatchPreview = false,
        GuardESP = false,
        GuardESPZones = {},
        ConfigName = "",
        SelectedConfig = "Default",
        CurrentAutoload = "Default",
        AutoLoadConfig = true,
        AutoSaveConfig = true,
    },
}

local Config, State = SylPhinCore.Config, SylPhinCore.State
local Shared = ReplicatedStorage:WaitForChild("Shared", Config.LoadTimeout)

SylPhinCore.GameLib = {
    Remote = setmetatable({}, {
        __index = function(self, name)
            local remote = ReplicatedStorage:FindFirstChild(name)
            if not remote then
                local nested = ReplicatedStorage:FindFirstChild(name, true)
                remote = nested and (nested:IsA("BaseRemoteEvent") or nested:IsA("RemoteFunction")) and nested or nil
            end
            if remote then rawset(self, name, remote) end
            return remote
        end,
    }),
}

function SylPhinCore.GameLib.RequireAsGame(module)
    local done, ok, loaded = false, false, nil
    task.spawn(function()
        pcall(setthreadidentity, 2)
        local read, identity = pcall(getthreadidentity)
        if read and identity == 2 then
            ok, loaded = pcall(require, module)
        end
        done = true
    end)
    local deadline = osClock() + Config.RequireTimeout
    while not done and osClock() < deadline do
        task.wait()
    end
    return ok, loaded
end

function SylPhinCore.GameLib.Require(name)
    local module = Shared and Shared:FindFirstChild(name)
    if not module then
        local nested = Shared and Shared:FindFirstChild(name, true)
        module = nested and nested:IsA("ModuleScript") and nested or nil
    end
    if not module then return nil end
    local ok, loaded = pcall(require, module)
    if ok then return loaded end
    local okAgain, again = SylPhinCore.GameLib.RequireAsGame(module)
    if okAgain then return again end
    return nil
end

local GameLib = SylPhinCore.GameLib

do
    local modules = {
        Eggs = "EggConfig", Rewards = "EggRewards", Rarity = "EggRarity", Pickaxe = "PickaxeConfig", Zones = "ZonesConfig",
        Plot = "PlotUpgradeConfig", Treadmill = "TreadmillUpgradeConfig", Trails = "TrailsConfig", Bat = "BatConfig", Speed = "SpeedConfig",
    }
    for key, name in pairs(modules) do
        GameLib[key] = GameLib.Require(name)
    end
    State.Opt.WalkSpeed = GameLib.Speed and GameLib.Speed.MaxWalkSpeed or Config.SpeedFallback
end

SylPhinCore.RarityLadder = {
    "Ethereal", "Spectral", "Omega", "Void", "Inferno", "Celestial", 
    "Secret", "Cosmic", "Divine", "Mythic", "Legendary", "Epic", 
    "Rare", "Uncommon", "Common"
}

SylPhinCore.RarityRank = {}
for i, name in ipairs(SylPhinCore.RarityLadder) do
    SylPhinCore.RarityRank[name] = i
end

SylPhinCore.RarityColors = {
    ["Ethereal"]  = "#FF55FF", ["Spectral"]  = "#55FFFF", ["Omega"]     = "#00FF66",
    ["Void"]      = "#AA55FF", ["Inferno"]   = "#FF3333", ["Celestial"] = "#FFEE55",
    ["Secret"]    = "#E0E0E0", ["Cosmic"]    = "#FF66CC", ["Divine"]    = "#70EDFF",
    ["Mythic"]    = "#FF4444", ["Legendary"] = "#FFB000", ["Epic"]      = "#AA00AA",
    ["Rare"]      = "#3399FF", ["Uncommon"]  = "#55FF55", ["Common"]    = "#AAAAAA"
}

SylPhinCore.AnimalData = {
    ["Hydrafang"] = "Ethereal", ["Shadowgale"] = "Ethereal",
    ["GhastlyOctopus"] = "Spectral", ["Glacierback"] = "Spectral", ["Stormwing"] = "Spectral",
    ["CelestialGorilla"] = "Omega", ["CelestialSpirit"] = "Omega", ["Hexhorn"] = "Omega",
    ["Spirewing"] = "Omega", ["UndeadCapybara"] = "Omega", ["VampirePorcupine"] = "Omega",
    ["BoneMammoth"] = "Void", ["CelestialAxolotl"] = "Void", ["CelestialBeast"] = "Void",
    ["CrystalWolf"] = "Void", ["Gearfang"] = "Void", ["PhantomBird"] = "Void",
    ["Voidhorn"] = "Void", ["ZombieAxolotl"] = "Void",
    ["AlienJellyfish"] = "Inferno", ["AngelDragon"] = "Inferno", ["AngelHydra"] = "Inferno",
    ["Behemoth"] = "Inferno", ["CelestialFrog"] = "Inferno", ["CLASSICDRAGON"] = "Inferno",
    ["CrystalScorpion"] = "Inferno", ["CursedKangaroo"] = "Inferno", ["HauntedMantis"] = "Inferno",
    ["HellDragon"] = "Inferno", ["HellHydra"] = "Inferno", ["Lilacwing"] = "Inferno",
    ["PenguinKing"] = "Inferno", ["QILIN"] = "Inferno", ["ScarecrowHorse"] = "Inferno",
    ["Thornmane"] = "Inferno", ["Velicoraptor"] = "Inferno", ["WitchSpider"] = "Inferno",
    ["Amphiptere"] = "Celestial", ["AngelMegalodon"] = "Celestial", ["AngelTRex"] = "Celestial",
    ["BoneHydra"] = "Celestial", ["BoneLion"] = "Celestial", ["CALADRIUS"] = "Celestial",
    ["CelestialSpiritFox"] = "Celestial", ["CERBERUS"] = "Celestial", ["Cinderclub"] = "Celestial",
    ["CrystalDragon"] = "Celestial", ["Gallimimus"] = "Celestial", ["HauntedCerberus"] = "Celestial",
    ["HauntedGriffin"] = "Celestial", ["HellDinoRex"] = "Celestial", ["HellMegalodon"] = "Celestial",
    ["HellTRex"] = "Celestial", ["Mantis"] = "Celestial", ["PossessedChameleon"] = "Celestial",
    ["Raiju"] = "Celestial", ["Sandbloom"] = "Celestial", ["ScarecrowLion"] = "Celestial",
    ["SIMURGH"] = "Celestial", ["VampiricBat"] = "Celestial", ["WINGED_IMP"] = "Celestial",
    ["Wolf"] = "Celestial",
    ["Akita"] = "Secret", ["AngelAnky"] = "Secret", ["AngelCroc"] = "Secret",
    ["AngelTrike"] = "Secret", ["ARCHAEOPTERYX"] = "Secret", ["BoneBat"] = "Secret",
    ["BoneHorse"] = "Secret", ["BoneRat"] = "Secret", ["CelestialLamb"] = "Secret",
    ["CrystalRaptor"] = "Secret", ["Duskcoil"] = "Secret", ["Fenrir"] = "Secret",
    ["HauntedKitsune"] = "Secret", ["HauntedWolf"] = "Secret", ["HellAnky"] = "Secret",
    ["HellCroc"] = "Secret", ["HellTrike"] = "Secret", ["MEGALODON"] = "Secret",
    ["Mossbelly"] = "Secret", ["PREHISTORIC_MOTH"] = "Secret", ["ScaredDog"] = "Secret",
    ["THUNDERBIRD"] = "Secret", ["Tidefin"] = "Secret", ["VampireCat"] = "Secret",
    ["BoneGuineaPig"] = "Cosmic", ["CrystalBeast"] = "Cosmic", ["DumboOctopus"] = "Cosmic",
    ["Frankenblob"] = "Cosmic", ["LanternDeer"] = "Cosmic", ["LeafySeaDragon"] = "Cosmic",
    ["PREHISTORIC_DRAGONFLY"] = "Cosmic", ["Regal"] = "Cosmic", ["ScarecrowRhino"] = "Cosmic",
    ["T-Rex"] = "Cosmic", ["Zebra"] = "Cosmic",
    ["Bug"] = "Divine", ["CandleWolf"] = "Divine", ["Cobra"] = "Divine",
    ["CrystalLizard"] = "Divine", ["GoblinShark"] = "Divine", ["Lindworm"] = "Divine",
    ["Mandarinfish"] = "Divine", ["Polar Bear"] = "Divine", ["ScarecrowOwl"] = "Divine",
    ["stingray"] = "Divine", ["Whale"] = "Divine",
    ["Brachiosaurus"] = "Mythic", ["Butterflyfish"] = "Mythic", ["CandleCat"] = "Mythic",
    ["Crocodile"] = "Mythic", ["Llama"] = "Mythic", ["MANTICORE"] = "Mythic",
    ["MantisShrimp"] = "Mythic", ["ScarecrowTurkey"] = "Mythic", ["Surgeonfish"] = "Mythic",
    ["Yak"] = "Mythic",
    ["Bear"] = "Legendary", ["CHIREMA"] = "Legendary", ["DIMETRODON"] = "Legendary",
    ["Moorish idol"] = "Legendary", ["pufferfish"] = "Legendary", ["SABER_TOOTHED_TIGER"] = "Legendary",
    ["SecretaryBird"] = "Legendary", ["Swordfish"] = "Legendary", ["Tanuki"] = "Legendary",
    ["barracuda"] = "Epic", ["BichonFrise"] = "Epic", ["FangtoothFish"] = "Epic",
    ["GoldenRetriver"] = "Epic", ["Jackalope"] = "Epic", ["Lizard"] = "Epic",
    ["SPHINX"] = "Epic", ["Unicorn"] = "Epic",
    ["Ankylosaurus"] = "Rare", ["Badger"] = "Rare", ["COCKATRICE"] = "Rare",
    ["Cuttlefish"] = "Rare", ["Goat"] = "Rare", ["Goldfish"] = "Rare",
    ["Maltese"] = "Rare", ["Muscovy Duck"] = "Rare", ["Parrot"] = "Rare",
    ["Snail"] = "Rare", ["trumpet"] = "Rare",
    ["Anteater"] = "Uncommon", ["Bat"] = "Uncommon", ["Bunny"] = "Uncommon",
    ["GuiennaPig"] = "Uncommon", ["Lion"] = "Uncommon", ["Pigeon"] = "Uncommon",
    ["Tiger"] = "Uncommon",
    ["Cat"] = "Common", ["Chicken"] = "Common", ["Snake"] = "Common"
}

local items = {}
for name, rarity in pairs(SylPhinCore.AnimalData) do
    local rank = SylPhinCore.RarityRank[rarity] or 99
    table.insert(items, {
        Name = name,
        Rarity = rarity,
        Rank = rank,
        Label = string.format("%02d. %s (%s)", rank, name, rarity)
    })
end

table.sort(items, function(a, b)
    if a.Rank ~= b.Rank then
        return a.Rank < b.Rank
    end
    return a.Name < b.Name
end)

SylPhinCore.AnimalList = {}
for _, item in ipairs(items) do
    table.insert(SylPhinCore.AnimalList, item.Label)
end

local function MatchAnimal(filterTable, inGameAnimalName)
    if not next(filterTable or {}) then return true end
    for selectedStr, state in pairs(filterTable) do
        if state then
            local cleanStr = selectedStr:gsub("^%d+%.%s*", "")
            local baseName = cleanStr:match("^(.-)%s*%(") or cleanStr
            if baseName == inGameAnimalName then
                return true
            end
        end
    end
    return false
end

SylPhinCore.ZoneList = {
    { Index = 1,  Name = "Forest" },
    { Index = 2,  Name = "Desert" },
    { Index = 3,  Name = "Snowy" },
    { Index = 4,  Name = "Candy" },
    { Index = 5,  Name = "Lake" },
    { Index = 6,  Name = "Under Water" },
    { Index = 7,  Name = "Volcano" },
    { Index = 8,  Name = "Blossom" },
    { Index = 9,  Name = "Galaxy" },
    { Index = 10, Name = "Planet X" },
    { Index = 11, Name = "Haunted Graveyard" },
    { Index = 12, Name = "Fairy Castle" },
}

function SylPhinCore.ParseFormat(str)
    if type(str) == "number" then return str end
    if type(str) ~= "string" then return 0 end

    str = str:gsub("%s+", ""):upper()
    if str == "" then return 0 end

    local numStr, unit = str:match("^([%d%.]+)(%a*)$")
    local num = tonumber(numStr)
    if not num then return 0 end

    local multipliers = {
        K = 1e3, M = 1e6, B = 1e9, T = 1e12, QA = 1e15,
        QI = 1e18, SX = 1e21, SP = 1e24, OC = 1e27, NO = 1e30, DC = 1e33
    }

    if unit and unit ~= "" then
        local mult = multipliers[unit]
        if mult then return num * mult end
    end
    return num
end

function SylPhinCore.Format(num)
    if not num or type(num) ~= "number" then return "0" end
    if num >= 1e12 then return string.format("%.2fT", num / 1e12) end
    if num >= 1e9 then return string.format("%.2fB", num / 1e9) end
    if num >= 1e6 then return string.format("%.2fM", num / 1e6) end
    if num >= 1e3 then return string.format("%.2fK", num / 1e3) end
    return tostring(math.floor(num))
end

SylPhinCore.Util = {}

function SylPhinCore.Util.HttpGet(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" then return body end
    local send = request or http_request or (syn and syn.request) or (http and http.request)
    if not send then return nil, tostring(body) end
    local sent, response = pcall(send, { Url = url, Method = "GET" })
    if not sent or type(response) ~= "table" or response.StatusCode ~= 200 then return nil end
    return response.Body
end

function SylPhinCore.Util.LoadLibrary()
    local body = SylPhinCore.Util.HttpGet(Config.UiSource)
    if not body then return nil end
    local chunk = loadstring(body)
    if not chunk then return nil end
    local ok, library = pcall(chunk)
    return ok and library or nil
end

function SylPhinCore:Character()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp and hum.Health > 0) then return nil end
    return char, hum, hrp
end

function SylPhinCore:Connect(signal, handler)
    local conn = signal:Connect(handler)
    table.insert(State.Connections, conn)
    return conn
end

function SylPhinCore:Fire(name, ...)
    local remote = GameLib.Remote[name] or ReplicatedStorage:FindFirstChild(name, true)
    if remote then remote:FireServer(...) end
end

function SylPhinCore.Attr(name, fallback)
    local value = LocalPlayer:GetAttribute(name)
    return value == nil and fallback or value
end

function SylPhinCore.Spendable()
    return SylPhinCore.Attr("Cash", 0) - (State.Opt.CashReserve or 0)
end

SylPhinCore.Move = {}

function SylPhinCore.Move.RespawnTp(targetCFrame)
    local char, hum = SylPhinCore:Character()
    if not char or not hum or hum.Health <= 0 then return end

    State.Status = "[⚡] Resetting không lag..."

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
            part.Enabled = false
        end
    end

    hum.Health = 0
    
    task.spawn(function()
        task.wait(0.05)
        if char and char.Parent then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then part:Destroy() end
            end
        end
    end)
    
    local newChar = LocalPlayer.CharacterAdded:Wait()
    local newHrp = newChar:WaitForChild("HumanoidRootPart", 10)
    
    if newHrp then
        newHrp.AssemblyLinearVelocity = Vector3.zero
        newHrp.AssemblyAngularVelocity = Vector3.zero
        newChar:PivotTo(targetCFrame)
        
        pcall(function()
            Workspace.CurrentCamera.CFrame = targetCFrame * CFrame.new(0, 5, 10)
            Workspace.CurrentCamera.Focus = targetCFrame
        end)
        task.wait(0.3)
    end
end

function SylPhinCore.Move.SmoothTo(targetCFrame, speed)
    local _, _, hrp = SylPhinCore:Character()
    if not hrp then return end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance > 130 then
        SylPhinCore.Move.RespawnTp(targetCFrame)
        return
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    local duration = math.clamp(distance / (speed or 250), 0.03, 0.08)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    tween.Completed:Wait()
    hrp.AssemblyLinearVelocity = Vector3.zero
end

function SylPhinCore.Move.To(cf)
    local _, _, hrp = SylPhinCore:Character()
    if not hrp then return false end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.CFrame = cf
    return true
end

function SylPhinCore.Move.ApplySpeed()
    local _, hum = SylPhinCore:Character()
    if not hum then return end
    if State.Opt.SpeedOn then
        hum.WalkSpeed = math.max(State.Opt.WalkSpeed, hum.WalkSpeed)
    end
end

local noclipConnection = nil

function SylPhinCore.Move.SetNoclip(on)
    if on then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

SylPhinCore.Base = {}

function SylPhinCore.Base.Own()
    local cached = State.Plot
    if cached and cached.Parent and cached:GetAttribute("OwnerUserId") == LocalPlayer.UserId then return cached end
    for _, plot in ipairs(Workspace.Plots:GetChildren()) do
        if plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            State.Plot = plot
            return plot
        end
    end
    return nil
end

function SylPhinCore.Base.GetBasePart()
    local plot = SylPhinCore.Base.Own()
    if plot then
        local hb = plot:FindFirstChild("Hitbox", true) or plot:FindFirstChild("Spawn", true) or plot.PrimaryPart
        if hb then return hb end
    end

    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases")
    if plotsFolder then
        for _, p in ipairs(plotsFolder:GetChildren()) do
            if p:GetAttribute("OwnerUserId") == LocalPlayer.UserId or p.Name:find(LocalPlayer.Name) then
                local hb = p:FindFirstChild("Hitbox", true) or p:FindFirstChild("Spawn", true) or p.PrimaryPart or p:FindFirstChildOfClass("BasePart")
                if hb then return hb end
            end
        end
    end
    return nil
end

function SylPhinCore.Base.Home()
    local hitbox = SylPhinCore.Base.GetBasePart()
    if hitbox then SylPhinCore.Move.To(hitbox.CFrame + vector3New(0, 2, 0)) end
end

function SylPhinCore.Base.Carry()
    return SylPhinCore.Attr("CarryCount", 0), SylPhinCore.Attr("SatchelCapacity", 1)
end

function SylPhinCore.Base.Bank()
    State.Status = "Banking"
    local before = SylPhinCore.Base.Carry()
    task.wait(0.2)

    local done = SylPhinCore.Base.Carry() == 0
    if done then
        State.Banked = State.Banked + before
        State.BreakSpot = nil
        State.Last.Banked = osClock()
        State.Requests.Place = State.Opt.AutoPlace or nil
    end
    return done
end

SylPhinCore.Pickup = {}

function SylPhinCore.Pickup.Value(model)
    if not model then return 0 end
    local directValue = model:GetAttribute("CashPerSecond") or model:GetAttribute("CPS") or model:GetAttribute("Value")
    if directValue then return tonumber(directValue) or 0 end

    local name = model:GetAttribute("AnimalName")
    if type(name) == "string" and GameLib.Rewards and GameLib.Rewards.PlacedCashPerSecond then
        local ok, val = pcall(GameLib.Rewards.PlacedCashPerSecond, name, model:GetAttribute("SizeMult") or 1, model:GetAttribute("Mutation"), model:GetAttribute("WeightKg"), model:GetAttribute("Variant"))
        if ok and val then return tonumber(val) or 0 end
    end
    return 0
end

function SylPhinCore.Pickup.PromptFor(model)
    if not model then return nil end
    local pos = model:GetPivot().Position
    local best, bestDist = nil, Config.PromptMatch or 30
    for _, prompt in ipairs(CollectionService:GetTagged("SmartPrompt")) do
        local anchor = prompt.Name == "StealPrompt" and prompt.Parent
        if anchor and anchor:IsA("BasePart") then
            local dist = (anchor.Position - pos).Magnitude
            if dist < bestDist then 
                best, bestDist = prompt, dist 
            end
        end
    end
    return best
end

function SylPhinCore.Pickup.Next()
    local folder = Workspace:FindFirstChild("AnimalPickups") or Workspace:FindFirstChild("Pickups") or Workspace:FindFirstChild("Pets")
    if not folder then return nil end

    local opt = State.Opt
    local priority = opt.TargetPriority or "Highest Money"
    local _, _, hrp = SylPhinCore:Character()
    local myPos = hrp and hrp.Position or Vector3.zero

    State.Skip = State.Skip or setmetatable({}, { __mode = "k" })
    local candidates = {}

    for _, model in ipairs(folder:GetChildren()) do
        if osClock() < (State.Skip[model] or 0) then continue end

        local animalName = model:GetAttribute("AnimalName") or model.Name
        if not MatchAnimal(opt.StealAnimals, animalName) then continue end

        local petValue = SylPhinCore.Pickup.Value(model)
        if petValue < (opt.StealMinValue or 0) then continue end

        local rarity = model:GetAttribute("Rarity") or "Common"
        local rank = SylPhinCore.RarityRank[rarity] or 0
        if next(opt.StealRarities or {}) then
            local isSelectedRarity = false
            for selectedName, state in pairs(opt.StealRarities) do
                if state and selectedName == rarity then
                    isSelectedRarity = true
                    break
                end
            end
            if not isSelectedRarity then continue end
        end

        local mutation = model:GetAttribute("Mutation") or "Normal"
        if next(opt.StealMutations or {}) then
            local isSelectedMutation = false
            for selectedMut, state in pairs(opt.StealMutations) do
                if state and selectedMut == mutation then
                    isSelectedMutation = true
                    break
                end
            end
            if not isSelectedMutation then continue end
        end

        local weight = model:GetAttribute("WeightKg") or model:GetAttribute("Weight") or 0
        local isMutated = (mutation ~= "Normal" and mutation ~= "") and 1 or 0
        local pos = model:GetPivot().Position
        local dist = (pos - myPos).Magnitude

        table.insert(candidates, {
            Model = model,
            Value = petValue,
            Rank = rank,
            Dist = dist,
            Weight = weight,
            IsMutated = isMutated
        })
    end

    if #candidates == 0 then return nil end

    table.sort(candidates, function(a, b)
        if priority == "Closest" then
            return a.Dist < b.Dist
        elseif priority == "Highest Rarity" then
            if a.Rank ~= b.Rank then return a.Rank > b.Rank end
            return a.Dist < b.Dist
        elseif priority == "Highest Money" then
            if a.Value ~= b.Value then return a.Value > b.Value end
            return a.Dist < b.Dist
        elseif priority == "Heaviest" then
            if a.Weight ~= b.Weight then return a.Weight > b.Weight end
            return a.Dist < b.Dist
        elseif priority == "Mutated First" then
            if a.IsMutated ~= b.IsMutated then return a.IsMutated > b.IsMutated end
            if a.Rank ~= b.Rank then return a.Rank > b.Rank end
            return a.Dist < b.Dist
        end
        return a.Dist < b.Dist
    end)

    return candidates[1].Model
end

function SylPhinCore.Pickup.Trigger(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
        return
    end
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration)
        prompt:InputHoldEnd()
    end
end

local function TriggerDropUI()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        for _, desc in ipairs(playerGui:GetDescendants()) do
            if (desc:IsA("TextButton") or desc:IsA("ImageButton")) and desc.Name:lower():find("drop") then
                if firesignal then
                    pcall(firesignal, desc.MouseButton1Click)
                    pcall(firesignal, desc.Activated)
                end
            elseif desc:IsA("TextLabel") and desc.Text == "Drop" then
                local btn = desc:FindFirstAncestorOfClass("GuiButton")
                if btn and firesignal then
                    pcall(firesignal, btn.MouseButton1Click)
                    pcall(firesignal, btn.Activated)
                end
            end
        end
    end

    for _, name in ipairs({"DropRemote", "DropAnimalRemote", "DropEggRemote", "DropPetRemote", "DropItem"}) do
        local remote = ReplicatedStorage:FindFirstChild(name, true)
        if remote and remote:IsA("RemoteEvent") then
            pcall(function() remote:FireServer() end)
        end
    end
end

function SylPhinCore.Pickup.Grab(model)
    State.Skip = State.Skip or setmetatable({}, { __mode = "k" })
    
    local success, result = pcall(function()
        if not model or not model.Parent then return false end

        local cachedPrompt = SylPhinCore.Pickup.PromptFor(model)
        if not cachedPrompt then
            State.Skip[model] = osClock() + Config.SkipFor
            return false
        end

        State.IsSequencing = true
        State.GlobalLockPet = model
        State.Status = "[🎯] Tiến tới nhặt Pet..."

        local petPos = model:GetPivot().Position
        local petCFrame = CFrame.new(petPos + Vector3.new(0, 2, 0))

        SylPhinCore.Move.SetNoclip(true)

        local char, hum, hrp = SylPhinCore:Character()
        if not hrp or not hum or hum.Health <= 0 then 
            SylPhinCore.Move.SetNoclip(false)
            return false 
        end

        local initDist = (hrp.Position - petCFrame.Position).Magnitude
        if initDist > 130 and SylPhinCore.Base.Carry() == 0 then
            SylPhinCore.Move.RespawnTp(petCFrame)
            task.wait(0.05)
        else
            SylPhinCore.Move.To(petCFrame)
            task.wait(0.03)
        end

        char, hum, hrp = SylPhinCore:Character()
        if not hrp or not hum or hum.Health <= 0 then 
            SylPhinCore.Move.SetNoclip(false)
            return false 
        end

        local beforeCarry = SylPhinCore.Base.Carry()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        
        SylPhinCore.Pickup.Trigger(cachedPrompt)
        
        local stealTimeout = osClock() + 0.4
        local gotPet = false

        while osClock() < stealTimeout do
            if SylPhinCore.Base.Carry() > beforeCarry 
               or not model.Parent 
               or model:IsDescendantOf(char) 
               or (LocalPlayer.Character and model.Parent == LocalPlayer.Character) then
                gotPet = true
                break
            end
            task.wait(0.02)
        end

        if gotPet or SylPhinCore.Base.Carry() > beforeCarry then
            task.wait(0.1)
        end

        State.Steals = (State.Steals or 0) + 1
        State.Skip[model] = osClock() + 15

        local hitbox = SylPhinCore.Base.GetBasePart()
        if hitbox and hrp then
            local dropOffset = CFrame.new(-129.70, -6.50, -53.18)
            local dropSpotCFrame = hitbox.CFrame * dropOffset

            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = dropSpotCFrame
            task.wait(0.05)

            State.Status = "[📦] Thả pet..."
            local dropTimeout = osClock() + 0.5
            local lastDropPress = 0

            while osClock() < dropTimeout do
                char, hum, hrp = SylPhinCore:Character()
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end

                if osClock() - lastDropPress > 0.12 then
                    TriggerDropUI()
                    lastDropPress = osClock()
                end
                task.wait(0.03)
            end

            State.Status = "[🔄] Nhặt lại pet..."
            local pickupTimeout = osClock() + 1.0

            while osClock() < pickupTimeout and SylPhinCore.Base.Carry() == 0 do
                char, hum, hrp = SylPhinCore:Character()
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end

                local targetPrompt = (cachedPrompt and cachedPrompt.Parent) and cachedPrompt or SylPhinCore.Pickup.PromptFor(model)
                if targetPrompt then
                    SylPhinCore.Pickup.Trigger(targetPrompt)
                end
                task.wait(0.04)
            end

            if SylPhinCore.Base.Carry() > 0 then
                State.Status = "[🏠] Cất pet về chuồng..."
                char, hum, hrp = SylPhinCore:Character()
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    hrp.CFrame = hitbox.CFrame * CFrame.new(0, 2, 0)
                end
                
                local bankTimeout = osClock() + 0.5
                while osClock() < bankTimeout and SylPhinCore.Base.Carry() > 0 do
                    task.wait(0.04)
                end
            end
        end

        SylPhinCore.Move.SetNoclip(false)
        return true
    end)

    State.GlobalLockPet = nil
    State.IsSequencing = false
    SylPhinCore.Move.SetNoclip(false)
    return success and result
end

SylPhinCore.Break = {}

function SylPhinCore.Break.Alive(egg)
    if not egg or not egg.Parent then return false end
    if egg:GetAttribute("Broken") == true then return false end
    local hp = egg:GetAttribute("Health")
    return hp == nil or hp > 0
end

function SylPhinCore.Break.UnequipPickaxe()
    local char, hum = SylPhinCore:Character()
    if char and hum then hum:UnequipTools() end
end

function SylPhinCore.Break.EquipPickaxe()
    local char, hum = SylPhinCore:Character()
    if not char or not hum then return false end
    if char:FindFirstChildOfClass("Tool") then return true end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("pickaxe") or tool.Name:lower():find("ufo")) then
                hum:EquipTool(tool)
                return true
            end
        end
        local anyTool = backpack:FindFirstChildOfClass("Tool")
        if anyTool then
            hum:EquipTool(anyTool)
            return true
        end
    end
    return false
end

local currentTargetEgg = nil
local lastPickedEgg = nil
local lastPickTime = 0

function SylPhinCore.Break.GetTitanicEgg()
    for _, egg in ipairs(CollectionService:GetTagged("BreakableEgg")) do
        if not SylPhinCore.Break.Alive(egg) then continue end

        local isEvent = egg:GetAttribute("Titanic") == true
                     or CollectionService:HasTag(egg, "TitanicEgg")
        local bracket = tostring(egg:GetAttribute("WeightBracket") or "")
        local eggType = tostring(egg:GetAttribute("EggType") or egg.Name):lower()

        if isEvent or bracket == "TITANIC" or eggType:find("titanic", 1, true) ~= nil then
            return egg, isEvent
        end
    end
    return nil, false
end

function SylPhinCore.Break.GetTitanicCountdown()
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text and desc.Text ~= "" then
            local cleanText = desc.Text:gsub("<[^>]+>", "")
            if cleanText:lower():find("spawns in") or cleanText:lower():find("titanic") then
                local timeMatch = cleanText:match("(%d+:%d+)") or cleanText:match("(%d+s)") or cleanText:match("(%d+%s*s)")
                if timeMatch then return timeMatch end
            end
        end
    end

    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        for _, desc in ipairs(playerGui:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Visible and desc.Text then
                local cleanText = desc.Text:gsub("<[^>]+>", "")
                if cleanText:lower():find("in:") or cleanText:lower():find("titanic") then
                    local timeMatch = cleanText:match("(%d+:%d+)") or cleanText:match("(%d+s)")
                    if timeMatch then return timeMatch end
                end
            end
        end
    end

    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text then
            local cleanText = desc.Text:gsub("<[^>]+>", "")
            local timeMatch = cleanText:match("(%d+:%d+)")
            if timeMatch and not cleanText:find("/") then
                return timeMatch
            end
        end
    end

    local titanicEgg = SylPhinCore.Break.GetTitanicEgg()
    if titanicEgg then return "Spawned!" end
    return "--"
end

local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

function SylPhinCore.Break.SyncAutoSwing(enable)
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    
    local targetBtn = nil
    for _, desc in ipairs(playerGui:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text and desc.Text:find("Auto Swing") then
            local curr = desc
            while curr and curr.Parent and not curr.Parent:IsA("ScreenGui") do
                if curr:IsA("GuiObject") and curr.AbsoluteSize.X > 40 and curr.Visible then
                    targetBtn = curr
                    break
                end
                curr = curr.Parent
            end
            if not targetBtn then targetBtn = desc end
            break
        end
    end

    if not targetBtn then return end

    pcall(function()
        local inset = GuiService:GetGuiInset()
        local absPos = targetBtn.AbsolutePosition
        local absSize = targetBtn.AbsoluteSize
        local clickX = absPos.X + (absSize.X / 2)
        local clickY = absPos.Y + (absSize.Y / 2) + inset.Y

        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
        task.wait(0.04)
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
    end)
end

function SylPhinCore.Break.Pick()
    local opt = State.Opt
    local titanicEgg, isEvent = SylPhinCore.Break.GetTitanicEgg()

    if titanicEgg and (opt.PrioritizeTitanicEgg or opt.AutoTitanicEgg) then
        lastPickedEgg = titanicEgg
        lastPickTime = osClock()
        return titanicEgg, isEvent
    end

    if not opt.AutoBreak then return nil, false end

    if osClock() - lastPickTime < 0.5 and lastPickedEgg and SylPhinCore.Break.Alive(lastPickedEgg) then
        return lastPickedEgg, false
    end
    
    lastPickTime = osClock()

    local bestEgg, closestDist = nil, math.huge
    local _, _, hrp = SylPhinCore:Character()
    local originPos = hrp and hrp.Position or Vector3.zero

    for _, egg in ipairs(CollectionService:GetTagged("BreakableEgg")) do
        if SylPhinCore.Break.Alive(egg) then

            if next(opt.BreakZones or {}) then
                local eggZoneIndex = egg:GetAttribute("ZoneIndex")
                local isSelectedZone = false

                for selectedName, state in pairs(opt.BreakZones) do
                    if state then
                        for _, z in ipairs(SylPhinCore.ZoneList or {}) do
                            if z.Name == selectedName and z.Index == eggZoneIndex then
                                isSelectedZone = true
                                break
                            end
                        end
                    end
                    if isSelectedZone then break end
                end

                if not isSelectedZone then continue end
            end

            if next(opt.BreakRarities or {}) then
                local eggRarity = tostring(egg:GetAttribute("Rarity") or egg:GetAttribute("EggType") or "Common")
                local isSelectedRarity = false
                for selectedName, state in pairs(opt.BreakRarities) do
                    if state and (selectedName:lower() == eggRarity:lower() or eggRarity:lower():find(selectedName:lower())) then
                        isSelectedRarity = true
                        break
                    end
                end
                if not isSelectedRarity then continue end
            end

            local dist = (egg.Position - originPos).Magnitude
            if dist < closestDist then
                closestDist = dist
                bestEgg = egg
            end
        end
    end
    
    lastPickedEgg = bestEgg
    return bestEgg, false
end

local function IsGameAutoSwingActive()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local animName = track.Name:lower()
                local animId = tostring(track.Animation and track.Animation.AnimationId or "")
                if animName:find("swing") or animName:find("pickaxe") or animName:find("mine") or animName:find("hit") or animId:find("swing") then
                    return true
                end
            end
        end
    end

    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        for _, desc in ipairs(playerGui:GetDescendants()) do
            if (desc:IsA("TextLabel") or desc:IsA("TextButton")) and desc.Text:find("Auto Swing") then
                local btn = desc:IsA("GuiObject") and desc or desc:FindFirstAncestorOfClass("GuiObject")
                if btn then
                    local c = btn.BackgroundColor3
                    if (c.G > c.R and c.G > 0.4) or btn:GetAttribute("Toggled") == true or btn:GetAttribute("Active") == true then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function SylPhinCore.Break.Hit(egg)
    if not egg or not egg.Parent or not egg:IsDescendantOf(workspace) then
        State.Status = "Hết trứng - Di chuyển tự do"
        currentTargetEgg = nil
        return
    end

    local char, hum, hrp = SylPhinCore:Character()
    if not hrp or not hum or hum.Health <= 0 then return end

    if hum.Health < hum.MaxHealth - 5 then
        State.Status = "Anti-Cheat Warning! Healing..."
        SylPhinCore.Break.UnequipPickaxe()
        task.wait(2.5)
        return
    end

    State.Status = ("Breaking %s"):format(tostring(egg:GetAttribute("EggType") or "Egg"))
    State.BreakSpot = egg.Position

    local targetPos = egg.Position
    if not targetPos or targetPos == Vector3.zero then return end

    local currentY = hrp.Position.Y
    local eggXZ = Vector3.new(targetPos.X, currentY, targetPos.Z)
    local dir = (hrp.Position - eggXZ)
    dir = (dir.Magnitude < 0.1) and Vector3.new(0, 0, 1) or dir.Unit
    
    local standPos = eggXZ + dir * 4.8
    local standCFrame = CFrame.lookAt(standPos, targetPos)
    local distance = (hrp.Position - standPos).Magnitude

    if distance > 2.5 or currentTargetEgg ~= egg then
        currentTargetEgg = egg

        SylPhinCore.Break.UnequipPickaxe()
        task.wait(0.08)

        if distance > 130 then
            SylPhinCore.Move.RespawnTp(standCFrame)
        elseif distance > 2.5 then
            SylPhinCore.Move.SmoothTo(standCFrame, 90)
        end

        task.wait(0.4)
    end

    char, hum, hrp = SylPhinCore:Character()
    if not hrp or not hum or hum.Health <= 0 then return end

    SylPhinCore.Break.EquipPickaxe()
    task.wait(0.2)

    local hitCount = 0
    local breakTimeout = osClock() + 8.0

    while SylPhinCore.Break.Alive(egg) and State.Opt.AutoBreak and osClock() < breakTimeout do
        if not egg or not egg.Parent or not egg:IsDescendantOf(workspace) then break end

        if State.Opt.AutoSteal and SylPhinCore.Pickup.Next() then
            SylPhinCore.Break.UnequipPickaxe()
            break
        end

        local cChar, cHum, cHrp = SylPhinCore:Character()
        if not cHum or cHum.Health < cHum.MaxHealth - 5 then
            State.Status = "Taking AC Damage! Disarming..."
            SylPhinCore.Break.UnequipPickaxe()
            task.wait(2.5)
            break
        end

        if cHrp then
            local currentDist = (cHrp.Position - targetPos).Magnitude
            if currentDist > 10 then
                cHrp.AssemblyLinearVelocity = Vector3.zero
                cHrp.AssemblyAngularVelocity = Vector3.zero
                cHrp.CFrame = CFrame.lookAt(targetPos + Vector3.new(0, 2, 3), targetPos)
                task.wait(0.05)
            end
        end

        if IsGameAutoSwingActive() then
            task.wait(0.2)
        else
            local currentTool = cChar and cChar:FindFirstChildOfClass("Tool")
            if currentTool then
                currentTool:Activate()
                SylPhinCore:Fire("EggHitRequest", egg)
                SylPhinCore:Fire("MasteryPickaxeSwing")

                hitCount = hitCount + 1
                if hitCount >= 4 then
                    hitCount = 0
                    task.wait(0.45)
                end
                task.wait(0.25)
            else
                SylPhinCore.Break.EquipPickaxe()
                task.wait(0.1)
            end
        end
    end

    if not SylPhinCore.Break.Alive(egg) then
        State.Broken = (State.Broken or 0) + 1
        currentTargetEgg = nil
        task.wait(0.1)
    end
end

SylPhinCore.Bat = {}

function SylPhinCore.Bat.Equip()
    local char, hum = SylPhinCore:Character()
    if not char or not hum then return false end
    
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and (currentTool.Name:lower():find("bat") or CollectionService:HasTag(currentTool, "BatTool")) then
        return true
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or CollectionService:HasTag(tool, "BatTool")) then
                hum:EquipTool(tool)
                return true
            end
        end

        local anyTool = backpack:FindFirstChildOfClass("Tool")
        if anyTool then
            hum:EquipTool(anyTool)
            return true
        end
    end
    return false
end

function SylPhinCore.Bat.RootOf(player)
    if not player or player == LocalPlayer then return nil end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp and hum.Health > 0) then return nil end
    return hrp
end

function SylPhinCore.Bat.Swing(player, approach)
    if not player or player == LocalPlayer then return false end
    local targetHrp = SylPhinCore.Bat.RootOf(player)
    if not targetHrp then return false end

    if osClock() - (State.Last.Bat or 0) < (Config.BatGap or 0.5) then return false end

    if not SylPhinCore.Bat.Equip() then return false end

    if approach then
        SylPhinCore.Move.To(targetHrp.CFrame * cframeNew(0, 0, 3))
        task.wait(Config.TpSettle or 0.1)
    end

    State.Last.Bat = osClock()

    pcall(function()
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end)

    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("BatHitRequest", true) 
                    or ReplicatedStorage:FindFirstChild("BatHit", true)
                    or ReplicatedStorage:FindFirstChild("HitPlayerRemote", true)

        if remote then
            if remote:IsA("RemoteEvent") then
                remote:FireServer(player)
                if player.Character then remote:FireServer(player.Character) end
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(player)
            end
        else
            SylPhinCore:Fire("BatHitRequest", player)
            if player.Character then SylPhinCore:Fire("BatHitRequest", player.Character) end
        end
    end)

    return true
end

function SylPhinCore.Bat.Carrier()
    local best, bestCount = nil, 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local count = player:GetAttribute("CarryCount") or 0
            if count > bestCount and SylPhinCore.Bat.RootOf(player) then 
                best, bestCount = player, count 
            end
        end
    end
    return best
end

task.spawn(function()
    while task.wait() do
        local opt = State.Opt
        if opt and opt.KillAura then
            pcall(function()
                local _, hum, hrp = SylPhinCore:Character()
                if hrp and hum and hum.Health > 0 then
                    for _, targetPlayer in ipairs(Players:GetPlayers()) do
                        if targetPlayer ~= LocalPlayer then
                            local targetHrp = SylPhinCore.Bat.RootOf(targetPlayer)
                            if targetHrp then
                                local dist = (hrp.Position - targetHrp.Position).Magnitude
                                if dist <= (opt.AuraRange or 15) then
                                    SylPhinCore.Bat.Swing(targetPlayer, false)
                                    task.wait(opt.AttackDelay or 0.1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        local opt = State.Opt
        if opt and opt.AntiRagdoll then
            pcall(function()
                local char, hum = SylPhinCore:Character()
                if char and hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                    hum.PlatformStand = false

                    for _, desc in ipairs(char:GetDescendants()) do
                        if desc:IsA("Motor6D") and not desc.Enabled then
                            desc.Enabled = true
                        elseif desc:IsA("BallSocketConstraint") or desc.Name:lower():find("ragdoll") then
                            desc:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

SylPhinCore.Farm = {}

local genv = getgenv and getgenv() or _G

if genv.__SYLPHIN_TREADMILL_RUNNING then
    genv.__SYLPHIN_TREADMILL_STOP = true
    task.wait(0.35)
end
genv.__SYLPHIN_TREADMILL_STOP = false
genv.__SYLPHIN_TREADMILL_RUNNING = true

local TrainState = {
    startedAt = nil,
    lastSnap = 0,
    unlockAskedAt = -1e9,
}

local function GetTreadmill()
    local plot = SylPhinCore.Base and SylPhinCore.Base.Own and SylPhinCore.Base.Own()
    if not plot then return nil, nil end

    for _, child in ipairs(plot:GetChildren()) do
        if child:IsA("Model") and child:GetAttribute("SpeedMultiplier") ~= nil then
            local hitbox = child:FindFirstChild("Hitbox") or child:FindFirstChild("Hitbox", true)
            if hitbox and hitbox:IsA("BasePart") then
                return child, hitbox
            end
        end
    end

    local tm = plot:FindFirstChild("Treadmill", true) or plot:FindFirstChild("SpeedTrain", true)
    if tm then
        local hb = tm:FindFirstChild("Hitbox", true)
            or tm:FindFirstChild("Belt", true)
            or tm.PrimaryPart
        if hb and hb:IsA("BasePart") then
            return tm, hb
        end
    end
    return nil, nil
end

local function TreadmillUnlocked()
    local plot = SylPhinCore.Base and SylPhinCore.Base.Own and SylPhinCore.Base.Own()
    if plot and plot:GetAttribute("TreadmillUnlocked") == true then
        return true
    end
    local _, hb = GetTreadmill()
    return hb ~= nil
end

local function SoftPlaceOnTreadmill(hrp, hb)
    if not (hrp and hb) then return end
    local top = hb.CFrame * CFrame.new(0, hb.Size.Y * 0.5 + 3, 0)
    hrp.CFrame = CFrame.new(top.Position, top.Position + hb.CFrame.LookVector)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

local function TrainStep()
    if genv.__SYLPHIN_TREADMILL_STOP then return false end
    if not (State and State.Opt and State.Opt.AutoTreadmill) then return false end

    if SylPhinCore.Base and SylPhinCore.Base.Carry and SylPhinCore.Base.Carry() > 0 then
        return false
    end

    local char, hum, hrp = SylPhinCore:Character()
    if not (char and hum and hrp and hum.Health > 0) then
        return false
    end

    if not TreadmillUnlocked() then
        local cost = 100
        local cash = (SylPhinCore.Spendable and SylPhinCore.Spendable()) or 0
        if cash >= cost and os.clock() - TrainState.unlockAskedAt > 10 then
            TrainState.unlockAskedAt = os.clock()
            State.Status = "[Unlock] Treadmill..."
            pcall(function() SylPhinCore:Fire("UnlockTreadmillRequest") end)
        else
            State.Status = "Treadmill locked ($" .. cost .. ")"
        end
        return false
    end

    local tm, hb = GetTreadmill()
    if not (tm and hb) then
        State.Status = "Looking for your treadmill"
        return false
    end

    local topPos = (hb.CFrame * CFrame.new(0, hb.Size.Y * 0.5 + 3, 0)).Position
    local offset = hrp.Position - topPos
    local distXZ = math.sqrt(offset.X * offset.X + offset.Z * offset.Z)

    if distXZ > 6 and os.clock() - TrainState.lastSnap > 1.5 then
        TrainState.lastSnap = os.clock()
        State.Status = "Going to your treadmill"
        SoftPlaceOnTreadmill(hrp, hb)
        return true
    end

    if not TrainState.startedAt then
        TrainState.startedAt = os.clock()
    end

    State.Status = string.format("Training · WalkSpeed %s", tostring(math.floor(hum.WalkSpeed)))

    if distXZ > 2.5 then
        local dir = Vector3.new(topPos.X - hrp.Position.X, 0, topPos.Z - hrp.Position.Z)
        if dir.Magnitude > 0.1 then hum:Move(dir.Unit, false) end
    else
        local look = Vector3.new(hb.CFrame.LookVector.X, 0, hb.CFrame.LookVector.Z)
        if look.Magnitude > 0.1 then
            hum:Move(look.Unit, false)
        else
            hum:Move(Vector3.new(0, 0, -1), true)
        end
    end

    return true
end

task.spawn(function()
    while not genv.__SYLPHIN_TREADMILL_STOP do
        task.wait(0.35)
        if not (State and State.Opt and State.Opt.AutoTreadmill) then
            TrainState.startedAt = nil
        else
            pcall(TrainStep)
        end
    end
    genv.__SYLPHIN_TREADMILL_RUNNING = false
end)

function SylPhinCore.Farm.Stand()
    local origin = State.FarmOrigin
    if not origin then return end
    State.FarmOrigin = nil
    State.BreakSpot = nil
    local _, _, hrp = SylPhinCore:Character()
    if hrp and not (SylPhinCore.Base.Carry() > 0 and SylPhinCore.Base.Bank()) and (hrp.Position - origin.Position).Magnitude > Config.StandRadius then
        SylPhinCore.Move.To(origin)
    end
    State.Status = "Idle"
end

function SylPhinCore.Farm.Step()
    local opt = State.Opt
    if not (opt.AutoSteal or opt.AutoBreak or opt.AutoTitanicEgg or opt.RobCarriers) then
        SylPhinCore.Farm.Stand()
        return
    end

    local _, _, hrp = SylPhinCore:Character()
    if not hrp then return end
    State.FarmOrigin = State.FarmOrigin or hrp.CFrame

    local carry, cap = SylPhinCore.Base.Carry()
    local hasTargetPet = opt.AutoSteal and (SylPhinCore.Pickup.Next() ~= nil)

    if carry >= cap or (carry > 0 and not hasTargetPet) or (SylPhinCore.Attr("BeingChased", false) and carry > 0) then
        State.Status = "[🏠] Đang cất Pet về base..."
        local banked = SylPhinCore.Base.Bank()
        if banked or SylPhinCore.Base.Carry() == 0 then
            State.Status = "[⏳] Hoàn tất cất pet..."
            task.wait(0.4)
        end
        return
    end

    if opt.AutoSteal then
        local nextPickup = (carry < cap) and SylPhinCore.Pickup.Next() or nil
        if nextPickup then
            SylPhinCore.Pickup.Grab(nextPickup)
            task.wait(0.15)
            return
        end
    end
    
    if opt.RobCarriers then
        local victim = SylPhinCore.Bat.Carrier()
        if victim then
            State.Status = "Robbing " .. victim.Name
            local root = SylPhinCore.Bat.RootOf(victim)
            if root then State.BreakSpot = root.Position end
            SylPhinCore.Bat.Swing(victim, true)
            return
        end
    end
    
    if opt.AutoBreak then
        local egg = SylPhinCore.Break.Pick()
        if egg then
            SylPhinCore.Break.Hit(egg)
            return
        end
        State.Status = "Searching for eggs..."
        return
    end

    State.Status = "Idle"
end

SylPhinCore.Shop = {}

function SylPhinCore.Shop.Treadmill()
    if not State.Opt.AutoUpgradeTreadmill then return end
    SylPhinCore:Fire("TreadmillUpgradeRequest")
    SylPhinCore:Fire("UpgradeTreadmillRequest")
end

function SylPhinCore.Shop.Pen()
    if not State.Opt.AutoUpgradePen then return end
    local plot = SylPhinCore.Base.Own()
    if not plot then return end
    SylPhinCore:Fire("UpgradePlotRequest")
    SylPhinCore:Fire("UpgradePenRequest")
end

function SylPhinCore.Shop.Trail()
    if not State.Opt.AutoBuyTrail then return end
    local cash = SylPhinCore.Spendable()
    local bestTier = nil

    if GameLib.Trails and GameLib.Trails.Tiers then
        for tier, data in ipairs(GameLib.Trails.Tiers) do
            local cost = data.Price or data.Cost or math.huge
            if cost <= cash then bestTier = tier end
        end
    end

    if bestTier then
        SylPhinCore:Fire("TrailShopRequest", "Buy", bestTier)
        SylPhinCore:Fire("BuyTrailRequest", bestTier)
    end
end

function SylPhinCore.Shop.Pickaxe()
    if not State.Opt.AutoBuyPickaxes then return false end
    local tier = SylPhinCore.Attr("PickaxeTier", 1)
    local cash = SylPhinCore.Spendable()
    local best = nil

    if GameLib.Pickaxe and GameLib.Pickaxe.Tiers then
        for nextTier = tier + 1, #GameLib.Pickaxe.Tiers do
            local getPrice = GameLib.Pickaxe.GetPrice or function(t) return GameLib.Pickaxe.Tiers[t] and GameLib.Pickaxe.Tiers[t].Price or math.huge end
            if getPrice(nextTier) > cash then break end
            best = nextTier
        end
    end

    if best then
        SylPhinCore:Fire("PickaxeShopRequest", "Buy", best)
        return true
    end
    return false
end

function SylPhinCore.Shop.Step()
    if State.Opt.AutoBuyPickaxes then SylPhinCore.Shop.Pickaxe() end
    if State.Opt.AutoUpgradePen then SylPhinCore.Shop.Pen() end
    if State.Opt.AutoUpgradeTreadmill then SylPhinCore.Shop.Treadmill() end
    if State.Opt.AutoBuyTrail then SylPhinCore.Shop.Trail() end
end

function SylPhinCore.Bat.EquipBest()
    if not State.Opt.AutoEquipBestBat then return end
    local char, hum = SylPhinCore:Character()
    if not char or not hum then return end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local bestBatTool = nil
    local maxPower = -1

    for _, container in ipairs({ backpack, char }) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("bat") or CollectionService:HasTag(tool, "BatTool")) then
                    local power = tool:GetAttribute("Power") or tool:GetAttribute("Damage") or 1
                    if power > maxPower then
                        maxPower = power
                        bestBatTool = tool
                    end
                end
            end
        end
    end

    if bestBatTool and bestBatTool.Parent ~= char then
        hum:EquipTool(bestBatTool)
    end

    local cash = SylPhinCore.Spendable()
    if GameLib.Bat and GameLib.Bat.Tiers then
        for tier, data in ipairs(GameLib.Bat.Tiers) do
            if (data.Price or math.huge) <= cash then
                SylPhinCore:Fire("BatShopRequest", "Buy", tier)
            end
        end
    end
end

SylPhinCore.Pets = {}

function SylPhinCore.Pets.Place()
    SylPhinCore:Fire("PetsInventoryRemote", "EquipBest", nil)
end

function SylPhinCore.Pets.Sell()
    local list = {}
    local opt = State.Opt
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and CollectionService:HasTag(tool, "AnimalTool") then
            local animalName = tool:GetAttribute("AnimalName") or tool.Name
            local rarity = tool:GetAttribute("Rarity") or "Common"
            local val = SylPhinCore.Pickup.Value(tool)

            local matchRarity = true
            if next(opt.SellRarities or {}) then
                matchRarity = false
                for selectedName, state in pairs(opt.SellRarities) do
                    if state and selectedName == rarity then
                        matchRarity = true
                        break
                    end
                end
            end

            local matchAnimal = true
            if next(opt.SellAnimals or {}) then
                matchAnimal = false
                for selectedName, state in pairs(opt.SellAnimals) do
                    if state and selectedName == animalName then
                        matchAnimal = true
                        break
                    end
                end
            end

            local matchValue = true
            if opt.SellBelowValue and opt.SellBelowValue > 0 then
                matchValue = (val <= opt.SellBelowValue)
            end

            if matchRarity and matchAnimal and matchValue then
                table.insert(list, tool)
            end
        end
    end
    if #list == 0 then return 0 end
    local remote = GameLib.Remote.BackpackSellRemote or ReplicatedStorage:FindFirstChild("BackpackSellRemote", true)
    if remote then pcall(remote.InvokeServer, remote, list) end
end

SylPhinCore.Eggs = SylPhinCore.Eggs or {}

local PlaceEgg = {
    lastAt = 0,
    cooldown = 1.0,
    minDist = 8,
    maxTries = 30,
}

local function HasActiveFilter(t)
    if type(t) ~= "table" then return false end
    for _, v in pairs(t) do
        if v == true then return true end
    end
    return false
end

local function GetPlotHitbox()
    local plot = SylPhinCore.Base and SylPhinCore.Base.Own and SylPhinCore.Base.Own()
    if not plot then return nil, nil end
    local hitbox = plot:FindFirstChild("Hitbox")
    if hitbox and hitbox:IsA("BasePart") then
        return plot, hitbox
    end
    return plot, plot.PrimaryPart or plot:FindFirstChildWhichIsA("BasePart", true)
end

local function GetPlacedEggPositions()
    local list = {}
    local function add(pos)
        if pos then table.insert(list, pos) end
    end

    for _, inst in ipairs(CollectionService:GetTagged("MergeEggPlaced")) do
        if inst.Parent then
            if inst:IsA("BasePart") then
                add(inst.Position)
            elseif inst:IsA("Model") then
                add(inst:GetPivot().Position)
            else
                local p = inst:FindFirstChildWhichIsA("BasePart", true)
                add(p and p.Position)
            end
        end
    end

    if #list == 0 then
        local plot = SylPhinCore.Base and SylPhinCore.Base.Own and SylPhinCore.Base.Own()
        if plot then
            for _, d in ipairs(plot:GetDescendants()) do
                if d:IsA("Model") and d:GetAttribute("EggType") ~= nil then
                    add(d:GetPivot().Position)
                end
            end
        end
    end
    return list
end

local function FarEnough(pos, existing, minDist)
    local m2 = minDist * minDist
    for i = 1, #existing do
        local o = existing[i]
        local dx, dz = pos.X - o.X, pos.Z - o.Z
        if dx * dx + dz * dz < m2 then return false end
    end
    return true
end

local function FindFreeSpot(hitbox)
    local existing = GetPlacedEggPositions()
    local half = hitbox.Size * 0.5
    local mx = math.max(half.X - 2, 1)
    local mz = math.max(half.Z - 2, 1)
    local y = hitbox.Position.Y + half.Y + 0.5

    for _ = 1, PlaceEgg.maxTries do
        local localPos = Vector3.new(
            (math.random() - 0.5) * 2 * mx,
            0,
            (math.random() - 0.5) * 2 * mz
        )
        local w = hitbox.CFrame:PointToWorldSpace(localPos)
        local spot = Vector3.new(w.X, y, w.Z)
        if FarEnough(spot, existing, PlaceEgg.minDist) then
            return spot
        end
    end
    return nil
end

local function IsEggTool(tool)
    if not tool:IsA("Tool") then return false end
    if CollectionService:HasTag(tool, "AnimalTool") then return false end
    if CollectionService:HasTag(tool, "MergeEggTool") then return true end
    if type(tool:GetAttribute("EggType")) == "string" then return true end
    return tool.Name:lower():find("egg", 1, true) ~= nil
end

function SylPhinCore.Eggs.Place()
    local opt = State.Opt
    if not (opt and opt.AutoPlaceEggs == true) then
        if State.Status and (State.Status:find("Place") or State.Status:find("Tele về plot")) then
            State.Status = "Idle"
        end
        return
    end

    if os.clock() - PlaceEgg.lastAt < PlaceEgg.cooldown then return end
    if SylPhinCore.Base and SylPhinCore.Base.Carry and SylPhinCore.Base.Carry() > 0 then return end

    local mergeRemote = ReplicatedStorage:FindFirstChild("MergeMachineRemote", true) or GameLib.Remote.PlaceEggRemote
    if not mergeRemote then return end

    local plot, hitbox = GetPlotHitbox()
    if not hitbox then
        State.Status = "[⏳] Không thấy plot Hitbox"
        return
    end

    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local hasRarity = HasActiveFilter(opt.PlaceRarities)
    local hasAnimal = HasActiveFilter(opt.PlaceAnimals)

    local function matchFilters(tool)
        local eggName = tool:GetAttribute("EggType") or tool:GetAttribute("AnimalName") or tool.Name
        local rarity = tool:GetAttribute("Rarity") or "Common"
        if hasRarity and opt.PlaceRarities[rarity] ~= true then return false end
        if hasAnimal then
            for selected, on in pairs(opt.PlaceAnimals) do
                if on == true then
                    local base = tostring(selected):gsub("^%d+%.%s*", ""):match("^(.-)%s*%(") or selected
                    if base == eggName or tool.Name:find(base, 1, true) then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end

    local eggTool = nil
    for _, container in ipairs({ backpack, char }) do
        if not container then continue end
        for _, tool in ipairs(container:GetChildren()) do
            if IsEggTool(tool) and matchFilters(tool) then
                eggTool = tool
                break
            end
        end
        if eggTool then break end
    end

    if not eggTool then
        if State.Status and (State.Status:find("Place") or State.Status:find("Tele về plot")) then
            State.Status = "Idle"
        end
        return
    end

    local spot = FindFreeSpot(hitbox)
    if not spot then
        State.Status = "[⏳] Plot đầy / không còn chỗ đủ xa trứng khác"
        return
    end

    local _, _, hrp = SylPhinCore:Character()
    if not hrp then return end

    local dist = (hrp.Position - hitbox.Position).Magnitude
    if dist > 25 then
        State.Status = "[🚀] Tele về plot để Place..."
        SylPhinCore.Move.To(hitbox.CFrame + Vector3.new(0, 3, 0))
        task.wait(0.25)
    end

    PlaceEgg.lastAt = os.clock()
    State.Status = string.format("[🥚] Place @ %.1f, %.1f", spot.X, spot.Z)

    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() hum:EquipTool(eggTool) end)
        task.wait(0.1)
    end

    pcall(function()
        if mergeRemote:IsA("RemoteFunction") then
            mergeRemote:InvokeServer("PlaceEgg", eggTool, spot)
        else
            mergeRemote:FireServer("PlaceEgg", eggTool, spot)
        end
    end)

    local t0 = os.clock()
    while os.clock() - t0 < 2 do
        if not eggTool.Parent or not eggTool:IsDescendantOf(LocalPlayer) then return end
        task.wait(0.1)
    end

    PlaceEgg.lastAt = os.clock() + 0.8
end

function SylPhinCore.Eggs.Hatch()
    if not State.Opt.AutoHatch then return end
    local done = 0
    local now = Workspace:GetServerTimeNow()

    for _, egg in ipairs(CollectionService:GetTagged("MergeEggPlaced")) do
        if egg:GetAttribute("OwnerUserId") == LocalPlayer.UserId
           and (egg:GetAttribute("ReadyAtServerTime") or math.huge) <= now then
            SylPhinCore:Fire("MergeMachineRemote", "HatchEgg", egg:GetAttribute("EggId"))
            done += 1
        end
    end

    return done
end

function SylPhinCore.Eggs.Sell()
    local list = {}
    local opt = State.Opt
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (CollectionService:HasTag(tool, "EggTool") or tool.Name:lower():find("egg")) then
            local eggName = tool:GetAttribute("EggType") or tool:GetAttribute("AnimalName") or tool.Name
            local rarity = tool:GetAttribute("Rarity") or "Common"
            local val = tool:GetAttribute("Value") or tool:GetAttribute("CashPerSecond") or 0

            local matchRarity = true
            if next(opt.SellRarities or {}) then
                matchRarity = false
                for selectedName, state in pairs(opt.SellRarities) do
                    if state and selectedName == rarity then
                        matchRarity = true
                        break
                    end
                end
            end

            local matchEgg = true
            if next(opt.SellAnimals or {}) then
                matchEgg = false
                for selectedName, state in pairs(opt.SellAnimals) do
                    if state and selectedName == eggName then
                        matchEgg = true
                        break
                    end
                end
            end

            local matchValue = true
            if opt.SellBelowValue and opt.SellBelowValue > 0 then
                matchValue = (val <= opt.SellBelowValue)
            end

            if matchRarity and matchEgg and matchValue then
                table.insert(list, tool)
            end
        end
    end
    if #list == 0 then return 0 end
    local remote = GameLib.Remote.EggSellRemote or GameLib.Remote.BackpackSellRemote or ReplicatedStorage:FindFirstChild("BackpackSellRemote", true)
    if remote then pcall(remote.InvokeServer, remote, list) end
end

function SylPhinCore.Pets.Merge()
    local opt = State.Opt
    if not (opt and opt.AutoMerge == true) then return end

    local hasAnimalFilter = HasActiveFilter(opt.MergeAnimals)
    local hasRarityFilter = HasActiveFilter(opt.MergeRarities)

    local validTools = {}
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local char = LocalPlayer.Character
    local containers = { backpack, char }

    for _, container in ipairs(containers) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    local tName = tool.Name:lower()
                    local isNotPet = tName:find("pickaxe") or tName:find("bat") or tName:find("ufo") or tName:find("egg")
                    
                    if not isNotPet then
                        local animalName = tool:GetAttribute("AnimalName") or tool.Name
                        local rarity = tool:GetAttribute("Rarity") or "Common"
                        local kg = tool:GetAttribute("WeightKg") or tool:GetAttribute("Weight") or 0
                        local val = SylPhinCore.Pickup.Value(tool)

                        local matchAnimal = true
                        if hasAnimalFilter then
                            matchAnimal = false
                            for selectedAnimal, state in pairs(opt.MergeAnimals) do
                                if state == true then
                                    local baseName = selectedAnimal:gsub("^%d+%.%s*", ""):match("^(.-)%s*%(") or selectedAnimal
                                    if baseName == animalName or tool.Name:find(baseName) then
                                        matchAnimal = true
                                        break
                                    end
                                end
                            end
                        end

                        local matchRarity = not hasRarityFilter or (opt.MergeRarities[rarity] == true)
                        local matchKg = (kg >= (opt.MergeMinKg or 0))
                        local matchValue = (not opt.MergeBelowValue or opt.MergeBelowValue <= 0 or val <= opt.MergeBelowValue)

                        if matchAnimal and matchRarity and matchKg and matchValue then
                            table.insert(validTools, tool)
                        end
                    end
                end
            end
        end
    end

    local groups = {}
    for _, tool in ipairs(validTools) do
        local name = tool:GetAttribute("AnimalName") or tool.Name
        local rarity = tool:GetAttribute("Rarity") or "Common"
        local key = name .. "_" .. rarity
        groups[key] = groups[key] or {}
        table.insert(groups[key], tool)
    end

    local targetGroup = nil
    for _, group in pairs(groups) do
        if #group >= 3 then
            targetGroup = group
            break
        end
    end

    if not targetGroup then
        State.Status = string.format("[Merge] Tìm thấy %d Pet hợp lệ (Chưa đủ 3 con cùng loại)", #validTools)
        return
    end

    local p1, p2, p3 = targetGroup[1], targetGroup[2], targetGroup[3]
    local petName = p1:GetAttribute("AnimalName") or p1.Name
    State.Status = string.format("[Merge] Đang ghép 3x %s...", petName)

    local mergeRemote = ReplicatedStorage:FindFirstChild("MergeMachineRemote", true)
                     or ReplicatedStorage:FindFirstChild("MergePetsRemote", true)
                     or ReplicatedStorage:FindFirstChild("MergeRemote", true)

    if mergeRemote then
        pcall(function()
            if mergeRemote:IsA("RemoteFunction") then
                pcall(function() mergeRemote:InvokeServer("Merge", p1, p2, p3) end)
                pcall(function() mergeRemote:InvokeServer("MergePets", p1, p2, p3) end)
                pcall(function() mergeRemote:InvokeServer({ p1, p2, p3 }) end)
            else
                pcall(function() mergeRemote:FireServer("Merge", p1, p2, p3) end)
                pcall(function() mergeRemote:FireServer("MergePets", p1, p2, p3) end)
                pcall(function() mergeRemote:FireServer("MergePets", { p1, p2, p3 }) end)
                pcall(function() mergeRemote:FireServer("Merge", { p1, p2, p3 }) end)
                pcall(function() mergeRemote:FireServer(p1, p2, p3) end)
            end
        end)
    end
end

SylPhinCore.Rewards = {}
function SylPhinCore.Rewards.Claim()
    SylPhinCore:Fire("IndexRemote", "ClaimAll", nil)
    SylPhinCore:Fire("OfflineRewardRemote", "Claim")
end

SylPhinCore.Scheduler = {}

function SylPhinCore.Scheduler.Every(stamp, interval, fn)
    if osClock() - (State.Last[stamp] or 0) < interval then return end
    State.Last[stamp] = osClock()
    pcall(fn)
end

function SylPhinCore.Scheduler.Side()
    local opt = State.Opt
    SylPhinCore.Scheduler.Every("Summary", 0.5, function()
        local cash = SylPhinCore.Attr("Cash", 0)
        State.Summary = ("Cash %s · Steals %d · Broken %d"):format(SylPhinCore.Format(cash), State.Steals, State.Broken)
        State.RunText = State.Status
    end)
    SylPhinCore.Scheduler.Every("ShopStep", Config.BuyInterval, SylPhinCore.Shop.Step)
    if opt.AutoClaimIndex then SylPhinCore.Scheduler.Every("ClaimIndex", Config.ClaimInterval, SylPhinCore.Rewards.Claim) end
    if opt.AutoEquipBestBat then SylPhinCore.Scheduler.Every("EquipBat", Config.EquipInterval, SylPhinCore.Bat.EquipBest) end
    if opt.AutoPlace then SylPhinCore.Scheduler.Every("Place", Config.EquipInterval, SylPhinCore.Pets.Place) end
    if opt.AutoSell then SylPhinCore.Scheduler.Every("Sell", Config.SellInterval, SylPhinCore.Pets.Sell) end
    if opt.AutoUpgrade then SylPhinCore.Scheduler.Every("Shop", Config.BuyInterval, SylPhinCore.Shop.Step) end
    if opt.AutoClaim then SylPhinCore.Scheduler.Every("Claim", Config.ClaimInterval, SylPhinCore.Rewards.Claim) end
    if opt.AutoSell then SylPhinCore.Scheduler.Every("SellPet", Config.SellInterval, SylPhinCore.Pets.Sell) end
    if opt.AutoSellEggs then SylPhinCore.Scheduler.Every("SellEgg", Config.SellInterval, SylPhinCore.Eggs.Sell) end
    if opt.AutoMerge then SylPhinCore.Scheduler.Every("MergePet", 3, SylPhinCore.Pets.Merge) end
    if opt.AutoEquipBest then SylPhinCore.Scheduler.Every("EquipBest", Config.EquipInterval, SylPhinCore.Pets.Place) end
    if opt.AutoPlaceEggs then SylPhinCore.Scheduler.Every("PlaceEgg", Config.EggInterval, SylPhinCore.Eggs.Place) end
    if opt.AutoHatch then SylPhinCore.Scheduler.Every("HatchEgg", 2, SylPhinCore.Eggs.Hatch) end
end

function SylPhinCore.Scheduler.Control()
    local _, hum, hrp = SylPhinCore:Character()
    if hrp and hum and hrp.Position.Y < -15 then 
        State.Status = "[⚠️] Phát hiện dính đất! Đang giải kẹt..."
        hrp.AssemblyLinearVelocity = Vector3.zero
        local hitbox = SylPhinCore.Base.GetBasePart()
        if hitbox then
            hrp.CFrame = hitbox.CFrame * CFrame.new(0, 5, 0)
            task.wait(0.3)
        else
            hum.Health = 0
            task.wait(0.5)
        end
    end

    SylPhinCore.Farm.Step()
end

function SylPhinCore.Scheduler.Boot()
    SylPhinCore:Connect(LocalPlayer.Idled, function()
        if not State.Opt.AntiAfk then return end
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    SylPhinCore:Connect(UserInputService.JumpRequest, function()
        if not State.Opt.InfJump then return end
        local _, hum = SylPhinCore:Character()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
    SylPhinCore:Connect(RunService.Stepped, function()
        if State.Opt.Noclip then SylPhinCore.Move.SetNoclip(true) end
    end)

    pcall(function()
        local Terrain = Workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterDetailLevel = Enum.WaterDetailLevel.Low
        end
        Lighting.GlobalShadows = false
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Sky") then
                obj:Destroy()
            end
        end
    end)

    task.spawn(function()
        while State.Alive do
            SylPhinCore.Scheduler.Side()
            task.wait(0.1)
        end
    end)
    task.spawn(function()
        while State.Alive do
            SylPhinCore.Scheduler.Control()
            task.wait(Config.TickDelay)
        end
    end)
end

local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local CONFIG_FOLDER = "SylPhinHub_Configs"

local GAME_DEFAULT_SPEED = 16 
local lastInteractTick = 0

RunService.Heartbeat:Connect(function()
    if not State or not State.Opt then return end
    local opt = State.Opt
    
    pcall(function()
        local char = game:GetService("Players").LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if hum and hum.Parent then
            if opt.EnableSpeed then
                hum.WalkSpeed = opt.SpeedValue or 32
            else
                local maxFarmedSpeed = GAME_DEFAULT_SPEED
                if GameLib and type(GameLib) == "table" and GameLib.Speed and type(GameLib.Speed) == "table" then
                    maxFarmedSpeed = GameLib.Speed.MaxWalkSpeed or GAME_DEFAULT_SPEED
                end
                
                if hum.WalkSpeed ~= maxFarmedSpeed and hum.WalkSpeed < maxFarmedSpeed then
                    hum.WalkSpeed = maxFarmedSpeed
                end
            end
        end
    end)

    if opt.InstantInteract then
        local now = os.clock()
        if now - lastInteractTick >= 0.5 then
            lastInteractTick = now
            pcall(function()
                for _, prompt in ipairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.HoldDuration > 0 then
                        prompt.HoldDuration = 0
                    end
                end
            end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.Opt.InfJump then
        local _, hum = SylPhinCore:Character()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local isReconnecting = false

GuiService.ErrorMessageChanged:Connect(function()
    if State.Opt.AutoReconnect and not isReconnecting then
        pcall(function()
            local errorType = GuiService:GetErrorCode()
            local errorMsg = GuiService.ErrorMessage:lower()
            
            if errorType == Enum.ConnectionError.DisconnectErrors or errorMsg:find("kick") or errorMsg:find("disconnect") or errorMsg:find("lost") then
                isReconnecting = true
                State.Status = "[🔄] Phát hiện mất kết nối! Đang tự động kết nối lại..."
                task.wait(5)
                
                local success, err = pcall(function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
                
                if not success then
                    isReconnecting = false
                    task.wait(10)
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if State.Opt.NoGameplayPaused then
            pcall(function()
                if GuiService.MenuIsOpen then
                    game:GetService("ContextActionService"):UnbindAction("RbxPlayerGuiPauseAction")
                    local char = game:GetService("Players").LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.PlatformStand = false end
                end
            end)
        end
    end
end)

GuiService.MenuOpened:Connect(function()
    if State.Opt.NoGameplayPaused then
        pcall(function()
            game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
        end)
    end
end)

local freecamPos = Vector3.zero
local freecamRotX = 0
local freecamRotY = 0
local isFreecamActive = false
local storedTransparencies = {}
local frozenRootPart = nil
local frozenCFrame = nil
local freezeConn = nil
local inputConn = nil
local renderConn = nil
local lastMousePos = nil

local function ToggleSoulFreecam(enable)
    State.Opt.Freecam = enable
    local char, hum, hrp = SylPhinCore:Character()
    local Camera = workspace.CurrentCamera
    
    if enable then
        if not isFreecamActive then
            isFreecamActive = true
            freecamPos = Camera.CFrame.Position
            local lookVector = Camera.CFrame.LookVector
            freecamRotX = math.asin(lookVector.Y)
            freecamRotY = math.atan2(-lookVector.X, -lookVector.Z)

            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CameraSubject = nil
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default

            if char and hrp and hum then
                frozenRootPart = hrp
                frozenCFrame = hrp.CFrame
                hum.WalkSpeed = 0
                hum.JumpPower = 0

                storedTransparencies = {}
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        storedTransparencies[part] = part.Transparency
                        part.Transparency = 0.5
                    end
                end

                freezeConn = RunService.Heartbeat:Connect(function()
                    if frozenRootPart and frozenCFrame then
                        frozenRootPart.CFrame = frozenCFrame
                        frozenRootPart.AssemblyLinearVelocity = Vector3.zero
                        frozenRootPart.AssemblyAngularVelocity = Vector3.zero
                    end
                end)
            end

            inputConn = UserInputService.InputChanged:Connect(function(input)
                if not isFreecamActive then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                        local currentMousePos = UserInputService:GetMouseLocation()
                        if lastMousePos then
                            local deltaX = currentMousePos.X - lastMousePos.X
                            local deltaY = currentMousePos.Y - lastMousePos.Y
                            local sensitivity = 0.004

                            freecamRotY = freecamRotY - deltaX * sensitivity
                            freecamRotX = freecamRotX - deltaY * sensitivity
                            freecamRotX = math.clamp(freecamRotX, -math.rad(89), math.rad(89))
                        end
                        lastMousePos = currentMousePos
                    else
                        lastMousePos = nil
                    end
                end
            end)

            renderConn = RunService.RenderStepped:Connect(function(dt)
                if not State.Opt.Freecam then return end
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CameraSubject = nil

                local moveVector = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveVector = moveVector + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveVector = moveVector - Vector3.new(0, 1, 0) end

                local speed = (State.Opt.FreecamSpeed or 50) * dt * (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 2.5 or 1)
                if moveVector.Magnitude > 0 then
                    freecamPos = freecamPos + (moveVector.Unit * speed)
                end

                Camera.CFrame = CFrame.new(freecamPos) * CFrame.Angles(0, freecamRotY, 0) * CFrame.Angles(freecamRotX, 0, 0)
            end)
        end
    else
        if isFreecamActive then
            isFreecamActive = false
            if freezeConn then freezeConn:Disconnect() freezeConn = nil end
            if inputConn then inputConn:Disconnect() inputConn = nil end
            if renderConn then renderConn:Disconnect() renderConn = nil end

            lastMousePos = nil
            Camera.CameraType = Enum.CameraType.Custom
            
            if hum then
                Camera.CameraSubject = hum
                hum.WalkSpeed = 16
                hum.JumpPower = 50
            end

            if char then
                for part, trans in pairs(storedTransparencies) do
                    if part and part.Parent then part.Transparency = trans end
                end
            end
            storedTransparencies = {}
            frozenRootPart = nil
            frozenCFrame = nil
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end
end

local OriginalSkyParent = {}
local OriginalBaseParts = {}
local OriginalDecals = {}
local OriginalParticles = {}
local OriginalLighting = {}

if _G.SylPhinFPSBoosterConn then
    pcall(function() _G.SylPhinFPSBoosterConn:Disconnect() end)
    _G.SylPhinFPSBoosterConn = nil
end

local function ToggleFPSBoost(enable)
    pcall(function()
        if enable then
            if OriginalLighting.GlobalShadows == nil then OriginalLighting.GlobalShadows = Lighting.GlobalShadows end
            if OriginalLighting.FogEnd == nil then OriginalLighting.FogEnd = Lighting.FogEnd end
            
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            
            for _, sky in ipairs(Lighting:GetChildren()) do
                if sky:IsA("Sky") or sky:IsA("Clouds") or sky:IsA("Atmosphere") then
                    if not OriginalSkyParent[sky] then OriginalSkyParent[sky] = sky.Parent end
                    sky.Parent = nil
                end
            end
            
            local function applyStyle(obj)
                if not obj or not obj.Parent then return end
                local nameLower = string.lower(obj.Name)
                if nameLower:find("tree") or nameLower:find("leaf") or nameLower:find("leaves") or nameLower:find("trunk") or nameLower:find("bush") or nameLower:find("plant") then
                    if obj:IsA("BasePart") or obj:IsA("Model") then
                        if not OriginalBaseParts[obj] then
                            OriginalBaseParts[obj] = { Parent = obj.Parent, Material = (obj:IsA("BasePart") and obj.Material or nil) }
                        end
                        obj.Parent = nil
                        return
                    end
                end

                if obj:IsA("BasePart") then
                    local playerChar = game:GetService("Players").LocalPlayer.Character
                    if playerChar and obj:IsDescendantOf(playerChar) then return end

                    if not OriginalBaseParts[obj] then
                        OriginalBaseParts[obj] = {
                            Parent = obj.Parent,
                            Material = obj.Material,
                            CastShadow = obj.CastShadow,
                            Reflectance = obj.Reflectance
                        }
                    end
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.CastShadow = false
                    obj.Reflectance = 0
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    if not OriginalDecals[obj] then OriginalDecals[obj] = obj.Transparency end
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Trail") then
                    if not OriginalParticles[obj] then OriginalParticles[obj] = obj.Enabled end
                    obj.Enabled = false
                end
            end

            for _, obj in ipairs(Workspace:GetDescendants()) do applyStyle(obj) end
            _G.SylPhinFPSBoosterConn = Workspace.DescendantAdded:Connect(function(newObj)
                task.wait()
                if _G.SylPhinFPSBoosterConn then pcall(applyStyle, newObj) end
            end)
        else
            if _G.SylPhinFPSBoosterConn then
                _G.SylPhinFPSBoosterConn:Disconnect()
                _G.SylPhinFPSBoosterConn = nil
            end
            
            if OriginalLighting.GlobalShadows ~= nil then Lighting.GlobalShadows = OriginalLighting.GlobalShadows end
            if OriginalLighting.FogEnd ~= nil then Lighting.FogEnd = OriginalLighting.FogEnd end
            
            for sky, parent in pairs(OriginalSkyParent) do
                pcall(function() if sky then sky.Parent = parent end end)
            end
            
            for obj, data in pairs(OriginalBaseParts) do
                pcall(function()
                    if obj then
                        if data.Parent and obj.Parent == nil then obj.Parent = data.Parent end
                        if obj:IsA("BasePart") then
                            if data.Material then obj.Material = data.Material end
                            if data.CastShadow ~= nil then obj.CastShadow = data.CastShadow end
                            if data.Reflectance then obj.Reflectance = data.Reflectance end
                        end
                    end
                end)
            end
            
            for obj, transparency in pairs(OriginalDecals) do
                pcall(function() if obj then obj.Transparency = transparency end end)
            end
            
            for obj, enabled in pairs(OriginalParticles) do
                pcall(function() if obj then obj.Enabled = enabled end end)
            end
            
            table.clear(OriginalSkyParent)
            table.clear(OriginalBaseParts)
            table.clear(OriginalDecals)
            table.clear(OriginalParticles)
            table.clear(OriginalLighting)
        end
    end)
end

local renderGui = Instance.new("ScreenGui")
renderGui.Name = "SylPhin_3DRenderGui"
renderGui.DisplayOrder = -99999
renderGui.ResetOnSpawn = false
renderGui.IgnoreGuiInset = true

pcall(function()
    if gethui then
        renderGui.Parent = gethui()
    else
        renderGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end)

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.fromScale(1, 1)
bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgFrame.BorderSizePixel = 0
bgFrame.Visible = false
bgFrame.Parent = renderGui

local function Update3DRender(disabled)
    State.Opt.Disable3DRender = disabled
    bgFrame.Visible = disabled
    
    local bgName = State.Opt.BackgroundTheme or "Black"
    local colorMap = {
        ["Black"] = Color3.fromRGB(0, 0, 0),
        ["Dark Purple"] = Color3.fromRGB(20, 10, 30),
        ["Midnight"] = Color3.fromRGB(10, 15, 30),
        ["Custom"] = Color3.fromRGB(15, 15, 15)
    }
    bgFrame.BackgroundColor3 = colorMap[bgName] or Color3.fromRGB(0, 0, 0)
end

local lastInputTime = os.clock()

UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Keyboard or 
       input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        lastInputTime = os.clock()
    end
end)

task.spawn(function()
    while task.wait(30) do 
        if State.Opt.AntiAFK then
            pcall(function()
                if os.clock() - lastInputTime >= 600 then
                    VirtualInputManager:SendMouseMoveEvent(1, 1, workspace.CurrentCamera)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseMoveEvent(0, 0, workspace.CurrentCamera)
                    lastInputTime = os.clock()
                end
            end)
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if State.Opt.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

local function JoinDiscord()
    local discordCode = "F2zUGYejx"
    local fullUrl = "https://discord.gg/" .. discordCode

    if setclipboard then setclipboard(fullUrl) end
    pcall(function()
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            req({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = { code = discordCode },
                    nonce = HttpService:GenerateGUID(false)
                })
            })
        end
    end)
end

local EggRarityColors = {
    ["Common"]    = Color3.fromRGB(255, 255, 255),
    ["Uncommon"]  = Color3.fromRGB(85, 255, 85),
    ["Rare"]      = Color3.fromRGB(85, 170, 255),
    ["Epic"]      = Color3.fromRGB(170, 85, 255),
    ["Legendary"] = Color3.fromRGB(255, 170, 0),
    ["Mythic"]    = Color3.fromRGB(255, 85, 85),
    ["Divine"]    = Color3.fromRGB(0, 255, 255),
    ["Cosmic"]    = Color3.fromRGB(255, 105, 180),
    ["Secret"]    = Color3.fromRGB(150, 150, 150),
    ["Celestial"] = Color3.fromRGB(255, 235, 59),
    ["Inferno"]   = Color3.fromRGB(255, 50, 50),
    ["Void"]      = Color3.fromRGB(138, 43, 226),
    ["Omega"]     = Color3.fromRGB(50, 205, 50),
    ["Spectral"]  = Color3.fromRGB(30, 144, 255),
    ["Ethereal"]  = Color3.fromRGB(238, 130, 238),
}

local Zone12Colors = {
    ["Zone 1"]  = Color3.fromRGB(85, 255, 85),
    ["Zone 2"]  = Color3.fromRGB(0, 255, 150),
    ["Zone 3"]  = Color3.fromRGB(0, 255, 255),
    ["Zone 4"]  = Color3.fromRGB(30, 144, 255),
    ["Zone 5"]  = Color3.fromRGB(138, 43, 226),
    ["Zone 6"]  = Color3.fromRGB(170, 85, 255),
    ["Zone 7"]  = Color3.fromRGB(255, 105, 180),
    ["Zone 8"]  = Color3.fromRGB(255, 170, 0),
    ["Zone 9"]  = Color3.fromRGB(255, 85, 85),
    ["Zone 10"] = Color3.fromRGB(255, 0, 0),
    ["Zone 11"] = Color3.fromRGB(255, 215, 0),
    ["Zone 12"] = Color3.fromRGB(0, 230, 230),
}

local function GetPlayerPlot()
    if SylPhinCore.Base and SylPhinCore.Base.Own then
        local p = SylPhinCore.Base.Own()
        if p then return p end
    end
    for _, folderName in ipairs({"Plots", "Bases", "Tycoons", "PlayerPlots"}) do
        local f = workspace:FindFirstChild(folderName)
        if f then
            for _, plot in ipairs(f:GetChildren()) do
                local owner = plot:GetAttribute("Owner") or plot:GetAttribute("Player") or (plot:FindFirstChild("Owner") and plot.Owner.Value)
                if owner == LocalPlayer or owner == LocalPlayer.Name or plot.Name:lower():find(LocalPlayer.Name:lower()) then
                    return plot
                end
            end
        end
    end
    return workspace:FindFirstChild(LocalPlayer.Name .. "'s Base") or workspace:FindFirstChild(LocalPlayer.Name .. "Plot")
end

local function IsInMyBase(obj)
    local myPlot = GetPlayerPlot()
    if myPlot and obj:IsDescendantOf(myPlot) then return true end
    return false
end

local function GetRarity(obj)
    for _, attrName in ipairs({"Rarity", "EggRarity", "PetRarity", "Tier", "EggType", "Quality", "RarityName"}) do
        local val = obj:GetAttribute(attrName)
        if val and tostring(val) ~= "" then
            local str = tostring(val)
            for rName in pairs(EggRarityColors) do
                if str:lower() == rName:lower() then return rName end
            end
            for rName in pairs(EggRarityColors) do
                if str:lower():find(rName:lower()) then return rName end
            end
            return str
        end
    end

    for _, desc in ipairs(obj:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text and desc.Text ~= "" then
            local txtLower = desc.Text:lower()
            for rName in pairs(EggRarityColors) do
                if txtLower == rName:lower() or txtLower:find(rName:lower()) then return rName end
            end
        elseif desc:IsA("StringValue") and desc.Value and desc.Value ~= "" then
            local valLower = desc.Value:lower()
            for rName in pairs(EggRarityColors) do
                if valLower == rName:lower() or valLower:find(rName:lower()) then return rName end
            end
        end
    end

    local objNameLower = obj.Name:lower()
    for rName in pairs(EggRarityColors) do
        if objNameLower:find(rName:lower()) then return rName end
    end

    return "Common"
end

local function IsEggRarityMatched(selectedTable, rarityVal)
    if not selectedTable or type(selectedTable) ~= "table" then return true end

    local activeRarities = {}
    local activeCount = 0

    for k, v in pairs(selectedTable) do
        if v == true then
            activeCount = activeCount + 1
            activeRarities[tostring(k):lower()] = true
        elseif type(k) == "number" and v then
            activeCount = activeCount + 1
            activeRarities[tostring(v):lower()] = true
        end
    end

    if activeCount == 0 then return true end

    local targetLower = tostring(rarityVal):lower()
    if activeRarities[targetLower] then return true end

    for activeRarity in pairs(activeRarities) do
        if targetLower:find(activeRarity) or activeRarity:find(targetLower) then return true end
    end

    return false
end

local function ParseValueToNumber(val)
    if type(val) == "number" then return val end
    if type(val) ~= "string" or val == "" then return nil end
    local cleanStr = val:gsub("%$", ""):gsub("/s", ""):gsub("%s+", ""):upper()
    local numStr, suffix = cleanStr:match("([%d%.]+)([KMBT]?)")
    if numStr then
        local n = tonumber(numStr)
        if not n then return nil end
        local mult = 1
        if suffix == "K" then mult = 1e3
        elseif suffix == "M" then mult = 1e6
        elseif suffix == "B" then mult = 1e9
        elseif suffix == "T" then mult = 1e12 end
        return n * mult
    end
    return nil
end

local function GetPetDetails(obj)
    local petName = nil
    local rarity = GetRarity(obj)
    local income = nil

    for k, v in pairs(obj:GetAttributes()) do
        local keyLower = tostring(k):lower()
        local valStr = tostring(v)
        if not petName and (keyLower:find("pet") or keyLower:find("animal") or keyLower:find("name") or keyLower:find("species")) then
            if not valStr:find("Merge") and not valStr:find("%-") and not valStr:lower():find("egg") and valStr ~= "" then
                petName = valStr
            end
        end
        if not income and (keyLower:find("income") or keyLower:find("cps") or keyLower:find("cash") or keyLower:find("money") or keyLower:find("rate")) then
            income = ParseValueToNumber(v) or valStr
        end
    end

    for _, desc in ipairs(obj:GetDescendants()) do
        if desc:IsA("ValueBase") then
            local nLower = desc.Name:lower()
            local val = desc.Value
            if not petName and (nLower:find("pet") or nLower:find("name")) and type(val) == "string" then
                if not val:find("Merge") and not val:find("%-") and not val:lower():find("egg") and val ~= "" then
                    petName = val
                end
            elseif not income and (nLower:find("income") or nLower:find("cps") or nLower:find("cash")) then
                income = ParseValueToNumber(val) or tostring(val)
            end
        elseif desc:IsA("TextLabel") and desc.Text ~= "" then
            local txt = desc.Text
            if (txt:find("%$") or txt:lower():find("/s")) and not income then
                income = txt
            elseif not petName and not txt:find("Merge") and not txt:find("%-") and not txt:lower():find("egg") then
                petName = txt
            end
        end
    end

    if not petName or petName == "" then
        petName = (not obj.Name:lower():find("egg") and not obj.Name:lower():find("model")) and obj.Name or "Pet"
    end

    return petName, rarity, income
end

local function GetEggPetInfo(egg)
    local petName, mutation, income = nil, nil, nil

    for k, v in pairs(egg:GetAttributes()) do
        local keyLower = tostring(k):lower()
        local valStr = tostring(v)
        if not petName and (keyLower:find("pet") or keyLower:find("animal") or keyLower:find("name") or keyLower:find("species")) then
            if not valStr:find("MergeEgg") and not valStr:find("%-") and not valStr:lower():find("egg") and valStr ~= "" then
                petName = valStr
            end
        end
        if not mutation and (keyLower:find("mutat") or keyLower:find("variant") or keyLower:find("shiny")) then
            if valStr ~= "" and valStr:lower() ~= "none" and valStr:lower() ~= "nil" and valStr:lower() ~= "normal" then
                mutation = valStr
            end
        end
        if not income and (keyLower:find("income") or keyLower:find("cps") or keyLower:find("cash") or keyLower:find("money") or keyLower:find("rate")) then
            income = ParseValueToNumber(v) or valStr
        end
    end

    for _, desc in ipairs(egg:GetDescendants()) do
        if desc:IsA("ValueBase") then
            local nLower = desc.Name:lower()
            local val = desc.Value
            if not petName and (nLower:find("pet") or nLower:find("name")) and type(val) == "string" then
                if not val:find("MergeEgg") and not val:find("%-") and not val:lower():find("egg") and val ~= "" then
                    petName = val
                end
            elseif not income and (nLower:find("income") or nLower:find("cps") or nLower:find("cash")) then
                income = ParseValueToNumber(val) or tostring(val)
            elseif not mutation and nLower:find("mutat") and type(val) == "string" then
                if val ~= "" and val:lower() ~= "none" then mutation = val end
            end
        elseif desc:IsA("TextLabel") and desc.Text ~= "" then
            local txt = desc.Text
            if (txt:find("%$") or txt:lower():find("/s")) and not income then
                income = txt
            elseif not petName and not txt:find("MergeEgg") and not txt:find("%-") and not txt:lower():find("egg") then
                petName = txt
            end
        end
    end

    petName = petName or egg:GetAttribute("Pet") or egg:GetAttribute("PetName") or "Pet"
    if tostring(petName):find("MergeEgg") or tostring(petName):find("%-") then petName = "Pet" end

    return petName, mutation, income
end

local function GetGuardZoneNum(npc)
    for _, attr in ipairs({"Zone", "ZoneNum", "ZoneIndex", "ZoneName", "Area"}) do
        local val = npc:GetAttribute(attr)
        local num = val and tostring(val):match("%d+")
        if num then return tonumber(num) end
    end
    local num = npc.Name:match("%d+")
    if num then return tonumber(num) end
    if npc.Parent then
        local pNum = npc.Parent.Name:match("%d+")
        if pNum then return tonumber(pNum) end
    end
    return 1
end

local espFolder = workspace:FindFirstChild("SylPhin_ESP") or Instance.new("Folder", workspace)
espFolder.Name = "SylPhin_ESP"

local activeESP = {}

task.spawn(function()
    while task.wait(0.25) do
        pcall(function()
            local currentFrameKeys = {}

            if not State.Opt.EggESP and not State.Opt.HatchPreview and not State.Opt.GuardESP then
                if next(activeESP) then
                    espFolder:ClearAllChildren()
                    table.clear(activeESP)
                end
                return
            end

            local myPlot = GetPlayerPlot()

            if State.Opt.HatchPreview and myPlot then
                for _, obj in ipairs(myPlot:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:find("Egg") or obj.Name:find("Merge") or obj:GetAttribute("HatchTime") or obj:GetAttribute("Pet")) then
                        local rootPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if rootPart then
                            local cacheKey = obj:GetFullName() .. "_hatch"
                            currentFrameKeys[cacheKey] = true

                            local petName, mutation, income = GetEggPetInfo(obj)
                            local labelLines = { petName }
                            if mutation then table.insert(labelLines, "[" .. mutation .. "]") end
                            if income then
                                local fmt = type(income) == "number" and ((SylPhinCore.Format and SylPhinCore.Format(income)) or tostring(income)) or tostring(income)
                                if not fmt:find("%$") then fmt = "$" .. fmt end
                                if not fmt:find("/s") then fmt = fmt .. "/s" end
                                table.insert(labelLines, fmt)
                            end
                            local textContent = table.concat(labelLines, "\n")

                            if activeESP[cacheKey] and activeESP[cacheKey].Parent then
                                local txtLabel = activeESP[cacheKey]:FindFirstChildOfClass("TextLabel")
                                if txtLabel then txtLabel.Text = textContent end
                            else
                                local bb = Instance.new("BillboardGui")
                                bb.Name = cacheKey
                                bb.Size = UDim2.new(0, 140, 0, 50)
                                bb.StudsOffset = Vector3.new(0, 3.5, 0)
                                bb.AlwaysOnTop = true
                                bb.Adornee = rootPart

                                local txt = Instance.new("TextLabel", bb)
                                txt.Size = UDim2.fromScale(1, 1)
                                txt.BackgroundTransparency = 1
                                txt.Text = textContent
                                txt.TextColor3 = Color3.fromRGB(0, 255, 170)
                                txt.TextStrokeTransparency = 0
                                txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                txt.Font = Enum.Font.GothamBold
                                txt.TextSize = 12

                                bb.Parent = espFolder
                                activeESP[cacheKey] = bb
                            end
                        end
                    end
                end
            end

            for _, obj in ipairs(workspace:GetDescendants()) do
                if not obj:IsA("Model") then continue end

                local isInsideMyBase = IsInMyBase(obj)

                if State.Opt.EggESP and not isInsideMyBase then
                    local nameLower = obj.Name:lower()
                    local isEgg = nameLower:find("egg") or obj:GetAttribute("EggType") ~= nil or obj:GetAttribute("HatchTime") ~= nil
                    local isPet = obj:GetAttribute("IsPet") == true or obj:GetAttribute("PetName") ~= nil or obj:GetAttribute("Pet") ~= nil or (not isEgg and obj:GetAttribute("Rarity") ~= nil)

                    if isEgg then
                        local rarity = GetRarity(obj)
                        if IsEggRarityMatched(State.Opt.EggESPRarities, rarity) then
                            local cacheKey = obj:GetFullName() .. "_eggesp"
                            currentFrameKeys[cacheKey] = true
                            local color = EggRarityColors[rarity] or Color3.fromRGB(85, 170, 255)

                            if not activeESP[cacheKey] or not activeESP[cacheKey].Parent then
                                local hl = Instance.new("Highlight")
                                hl.Name = cacheKey
                                hl.Adornee = obj
                                hl.FillTransparency = 1
                                hl.OutlineColor = color
                                hl.OutlineTransparency = 0.05
                                hl.Parent = espFolder
                                activeESP[cacheKey] = hl
                            else
                                activeESP[cacheKey].OutlineColor = color
                            end
                        end

                    elseif isPet and not nameLower:find("guard") then
                        local petName, rarity, income = GetPetDetails(obj)
                        if IsEggRarityMatched(State.Opt.EggESPRarities, rarity) then
                            local rootPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            local color = EggRarityColors[rarity] or Color3.fromRGB(255, 255, 255)
                            local cacheKey = obj:GetFullName() .. "_petesp"
                            currentFrameKeys[cacheKey] = true

                            if not activeESP[cacheKey] or not activeESP[cacheKey].Parent then
                                local hl = Instance.new("Highlight")
                                hl.Name = cacheKey
                                hl.Adornee = obj
                                hl.FillTransparency = 1
                                hl.OutlineColor = color
                                hl.OutlineTransparency = 0.05
                                hl.Parent = espFolder
                                activeESP[cacheKey] = hl
                            else
                                activeESP[cacheKey].OutlineColor = color
                            end

                            if rootPart then
                                local bbKey = cacheKey .. "_bb"
                                currentFrameKeys[bbKey] = true

                                local labelLines = { petName, "[" .. rarity .. "]" }
                                if income then
                                    local fmt = type(income) == "number" and ((SylPhinCore.Format and SylPhinCore.Format(income)) or tostring(income)) or tostring(income)
                                    if not fmt:find("%$") then fmt = "$" .. fmt end
                                    if not fmt:find("/s") then fmt = fmt .. "/s" end
                                    table.insert(labelLines, fmt)
                                end
                                local textContent = table.concat(labelLines, "\n")

                                if activeESP[bbKey] and activeESP[bbKey].Parent then
                                    local txtLabel = activeESP[bbKey]:FindFirstChildOfClass("TextLabel")
                                    if txtLabel then txtLabel.Text = textContent end
                                else
                                    local bb = Instance.new("BillboardGui")
                                    bb.Name = bbKey
                                    bb.Size = UDim2.new(0, 140, 0, 55)
                                    bb.StudsOffset = Vector3.new(0, 3.5, 0)
                                    bb.AlwaysOnTop = true
                                    bb.Adornee = rootPart

                                    local txt = Instance.new("TextLabel", bb)
                                    txt.Size = UDim2.fromScale(1, 1)
                                    txt.BackgroundTransparency = 1
                                    txt.Text = textContent
                                    txt.TextColor3 = color
                                    txt.TextStrokeTransparency = 0
                                    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                    txt.Font = Enum.Font.GothamBold
                                    txt.TextSize = 12

                                    bb.Parent = espFolder
                                    activeESP[bbKey] = bb
                                end
                            end
                        end
                    end
                end

                if State.Opt.GuardESP then
                    local isGuard = false
                    if obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) and not isInsideMyBase then
                        isGuard = true
                    elseif obj.Name:lower():find("guard") or obj:GetAttribute("IsGuard") == true then
                        isGuard = true
                    end

                    if isGuard and not obj.Name:lower():find("egg") then
                        local zNum = GetGuardZoneNum(obj)
                        local zoneName = "Zone " .. zNum
                        local color = Zone12Colors[zoneName] or Color3.fromRGB(255, 120, 0)
                        local cacheKey = obj:GetFullName() .. "_guardesp"
                        currentFrameKeys[cacheKey] = true

                        if not activeESP[cacheKey] or not activeESP[cacheKey].Parent then
                            local hl = Instance.new("Highlight")
                            hl.Name = cacheKey
                            hl.Adornee = obj
                            hl.FillTransparency = 1
                            hl.OutlineColor = color
                            hl.OutlineTransparency = 0.05
                            hl.Parent = espFolder
                            activeESP[cacheKey] = hl
                        else
                            activeESP[cacheKey].OutlineColor = color
                        end

                        local head = obj:FindFirstChild("Head") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if head then
                            local bbKey = cacheKey .. "_bb"
                            currentFrameKeys[bbKey] = true
                            local textContent = zoneName .. "\n" .. obj.Name

                            if activeESP[bbKey] and activeESP[bbKey].Parent then
                                local txtLabel = activeESP[bbKey]:FindFirstChildOfClass("TextLabel")
                                if txtLabel then txtLabel.Text = textContent end
                            else
                                local bb = Instance.new("BillboardGui")
                                bb.Name = bbKey
                                bb.Size = UDim2.new(0, 110, 0, 35)
                                bb.StudsOffset = Vector3.new(0, 3, 0)
                                bb.AlwaysOnTop = true
                                bb.Adornee = head

                                local txt = Instance.new("TextLabel", bb)
                                txt.Size = UDim2.fromScale(1, 1)
                                txt.BackgroundTransparency = 1
                                txt.Text = textContent
                                txt.TextColor3 = color
                                txt.TextStrokeTransparency = 0
                                txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                txt.Font = Enum.Font.GothamBold
                                txt.TextSize = 13

                                bb.Parent = espFolder
                                activeESP[bbKey] = bb
                            end
                        end
                    end
                end
            end

            for key, guiObj in pairs(activeESP) do
                if not currentFrameKeys[key] then
                    if guiObj and guiObj.Parent then guiObj:Destroy() end
                    activeESP[key] = nil
                end
            end
        end)
    end
end)

if makefolder and not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end

local ConfigSystem = {}

function ConfigSystem.GetList()
    local list = { "Default" }
    if listfiles then
        pcall(function()
            for _, filePath in ipairs(listfiles(CONFIG_FOLDER)) do
                local fileName = filePath:match("([^/\\]+)%.json$")
                if fileName and fileName ~= "Default" and fileName ~= "_Autoload_" then
                    table.insert(list, fileName)
                end
            end
        end)
    end
    return list
end

function ConfigSystem.Save(name)
    if not writefile then return end
    pcall(function()
        local cleanName = tostring(name)
        local path = CONFIG_FOLDER .. "/" .. cleanName .. ".json"
        writefile(path, HttpService:JSONEncode(State.Opt))
    end)
end

function ConfigSystem.Load(name, Library)
    if not readfile or not isfile then return end
    pcall(function()
        local targetName = tostring(name)
        if type(name) == "number" then
            local list = ConfigSystem.GetList()
            targetName = list[name] or "Default"
        end

        local path = CONFIG_FOLDER .. "/" .. targetName .. ".json"
        if isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            if type(data) == "table" then
                for k, v in pairs(data) do
                    State.Opt[k] = v
                end

                if Library then
                    local options = Library.Options or Options
                    local toggles = Library.Toggles or Toggles
                    
                    for k, v in pairs(data) do
                        local elem = (options and options[k]) or (toggles and toggles[k])
                        if elem and type(elem.SetValue) == "function" then
                            pcall(function() elem:SetValue(v) end)
                        end
                    end
                end

                pcall(function()
                    if ToggleFPSBoost then ToggleFPSBoost(State.Opt.FPSBoost == true) end
                    if Update3DRender then Update3DRender(State.Opt.Disable3DRender == true) end
                    if ToggleSoulFreecam then ToggleSoulFreecam(State.Opt.Freecam == true) end
                end)
            end
        end
    end)
end

function ConfigSystem.Delete(name)
    if name == "Default" or name == "_Autoload_" then return end
    pcall(function()
        if delfile and isfile then
            local path = CONFIG_FOLDER .. "/" .. tostring(name) .. ".json"
            if isfile(path) then delfile(path) end
        end
    end)
end

local function BuildInterface()
    local Library = SylPhinCore.Util.LoadLibrary()
    if not Library then return end
    
    local opt = State.Opt

    local Window = Library:CreateWindow({
        Title = "SylPhin Hub",
        SubTitle = "Break and Steal an Egg (Premium)",
        MenuKey = Enum.KeyCode.RightControl,
        ConfigFolder = Config.SaveFolder,
        OnUnlocked = function()
            SylPhinCore.Scheduler.Boot()
        end,
    })

    if not Window then return end

    local function Toggle(group, key, info)
       info.Default = false
       local customCallback = info.Callback
       info.Callback = function(value)
           opt[key] = value
           if customCallback then
               task.spawn(customCallback, value)
           end
       end
       return group:AddToggle(key, info)
   end

    local function Feature(group, key, info)
        return Toggle(group, key, info):AddKeyPicker(key .. "Key", { Default = "None", Mode = "Toggle" })
    end

    local mainTab = Window:AddTab("Main", "house", "Main Control")
    local statusBox = mainTab:AddLeftGroupbox("Status", "star")
    local labels = {
        Summary = statusBox:AddLabel("Loading..."),
        Run = statusBox:AddLabel("-"),
    }
    
    local farmTab = Window:AddTab("Farm", "star", "Farm Eggs and Animals")
    local breakBox = farmTab:AddLeftGroupbox("Auto Break")
    
    breakBox:AddDropdown("BreakRarities", {
        Text = "Filter Rarity",
        Values = SylPhinCore.RarityLadder,
        Default = {},
        Multi = true,
        Callback = function(Value) State.Opt.BreakRarities = Value end,
    })

    breakBox:AddDropdown("BreakZones", {
        Text = "Filter Zones",
        Values = (function()
            local names = {}
            for _, zone in ipairs(SylPhinCore.ZoneList or {}) do names[#names + 1] = zone.Name end
            return names
        end)(),
        Default = {},
        Multi = true,
        Callback = function(Value) State.Opt.BreakZones = Value end,
    })

    Feature(breakBox, "AutoBreak", { Text = "Auto Break Eggs", Description = "Auto Teleport and Break Eggs" })
    
    Toggle(breakBox, "AutoTitanicEgg", { 
        Text = "Auto Titanic Egg", 
        Tooltip = "Breaks the titanic egg when it spawns",
        Callback = function(Value) State.Opt.AutoTitanicEgg = Value end
    })

    Toggle(breakBox, "PrioritizeTitanicEgg", { 
        Text = "Prioritize Titanic Egg", 
        Tooltip = "Titanic egg goes first",
        Callback = function(Value) State.Opt.PrioritizeTitanicEgg = Value end
    })

    Toggle(breakBox, "AutoSwing", { 
        Text = "Auto Swing", 
        Tooltip = "Bật/Tắt nút Auto Swing gốc của game",
        Callback = function(Value) 
            State.Opt.AutoSwing = Value
            SylPhinCore.Break.SyncAutoSwing(Value)
        end
    })

    local titanicLabel = breakBox:AddLabel("Titanic: next in --s")

    task.spawn(function()
       while task.wait(1) do
            if not titanicLabel then continue end
            local cd = SylPhinCore.Break.GetTitanicCountdown()
            if cd == "Spawned!" then
                titanicLabel:SetText("Titanic: Spawned!")
            elseif cd == "N/A" then
                titanicLabel:SetText("Titanic: --")
            else
                titanicLabel:SetText("Titanic: next in " .. cd)
            end
        end
    end)

    local stealBox = farmTab:AddRightGroupbox("Auto Steal", "star")
    
    stealBox:AddDropdown("StealRarities", {
        Text = "Filter Rarity",
        Values = SylPhinCore.RarityLadder,
        Default = {},
        Multi = true,
        Callback = function(Value) opt.StealRarities = Value end,
    })

    stealBox:AddDropdown("StealAnimals", {
        Text = "Filter Animals",
        Values = SylPhinCore.AnimalList,
        Default = {},
        Multi = true,
        Callback = function(Value) opt.StealAnimals = Value end,
    })

    stealBox:AddDropdown("StealMutations", {
        Text = "Filter Mutation",
        Values = { "Gold", "Diamond", "Lightning", "Frozen", "Angelic" },
        Default = {},
        Multi = true,
        Callback = function(Value) opt.StealMutations = Value end,
    })
    
    stealBox:AddDropdown("TargetPriority", {
        Text = "Target Priority",
        Values = { "Highest Money", "Closest", "Highest Rarity", "Heaviest", "Mutated First" },
        Default = "Highest Money",
        Multi = false,
        Callback = function(Value) opt.TargetPriority = Value end,
    })

    stealBox:AddInput("StealMinValue", {
        Default = "0",
        Numeric = false,
        Finished = false,
        Text = "Minimum $/s",
        Placeholder = "VD: 100K, 50M, 1B, 100T",
        Callback = function(Value) opt.StealMinValue = SylPhinCore.ParseFormat(Value) end,
    })
    
    Feature(stealBox, "AutoSteal", { Text = "Auto Steal", Description = "Steal Animals from map" })
    
    local farmBox = farmTab:AddLeftGroupbox("Treadmill")

    Feature(farmBox, "AutoTreadmill", { 
        Text = "Auto Treadmill", 
        Callback = function(Value) State.Opt.AutoTreadmill = Value end
    })

    local inventoryTab = Window:AddTab("Inventory", "box", "Inventory Control")
    local progressionTab = Window:AddTab("Progression", "trending-up", "Progression & Upgrades")
    local autoUpgradeBox = progressionTab:AddLeftGroupbox("Automatic Upgrades", "zap")

    Feature(autoUpgradeBox, "AutoUpgradeTreadmill", { Text = "Auto Upgrade Treadmill" })
    Feature(autoUpgradeBox, "AutoUpgradePen", { Text = "Auto Upgrade Pen" })
    Feature(autoUpgradeBox, "AutoBuyTrail", { Text = "Auto Buy Trail" })
    Feature(autoUpgradeBox, "AutoBuyPickaxes", { Text = "Auto Buy Pickaxes" })
    Feature(autoUpgradeBox, "AutoClaimIndex", { Text = "Auto Claim Index" })
    Feature(autoUpgradeBox, "AutoEquipBestBat", { Text = "Auto Equip Best Bat" })

    local lifecycleBox = inventoryTab:AddLeftGroupbox("Egg Lifecycle", "egg")

    Feature(lifecycleBox, "AutoPlaceEggs", { Text = "Auto Place Eggs" })

    lifecycleBox:AddDropdown("PlaceRarities", {
        Text = "Filter Rarity (Place)",
        Values = SylPhinCore.RarityLadder,
        Default = {},
        Multi = true,
        Callback = function(Value) opt.PlaceRarities = Value end,
    })

    lifecycleBox:AddDropdown("PlaceAnimals", {
        Text = "Filter Animals / Eggs (Place)",
        Values = SylPhinCore.AnimalList,
        Default = {},
        Multi = true,
        Callback = function(Value) opt.PlaceAnimals = Value end,
    })

    Feature(lifecycleBox, "AutoHatch", { Text = "Auto Hatch" })
    Feature(lifecycleBox, "AutoEquipBest", { Text = "Auto Equip Best" })

    local sellBox = inventoryTab:AddLeftGroupbox("Auto Sell", "dollar")
    Feature(sellBox, "AutoSell", { Text = "Auto Sell Pets" })
    Feature(sellBox, "AutoSellEggs", { Text = "Auto Sell Eggs" })

    sellBox:AddDropdown("SellRarities", {
        Text = "Filter Rarity",
        Values = SylPhinCore.RarityLadder,
        Default = {},
        Multi = true,
        Callback = function(Value) opt.SellRarities = Value end,
    })

    sellBox:AddDropdown("SellAnimals", {
        Text = "Filter Animals / Eggs",
        Values = SylPhinCore.AnimalList,
        Default = {},
        Multi = true,
        Callback = function(Value) opt.SellAnimals = Value end,
    })

    sellBox:AddInput("SellBelowValue", {
        Default = "0",
        Numeric = false,
        Finished = false,
        Text = "Sell Below $/s",
        Placeholder = "VD: 100K, 50M, 1B",
        Callback = function(Value) opt.SellBelowValue = SylPhinCore.ParseFormat(Value) end,
    })

    local mergeBox = inventoryTab:AddRightGroupbox("Auto Merge", "zap")
    Feature(mergeBox, "AutoMerge", { Text = "Auto Merge", Description = "Tự động gộp Pet" })

    mergeBox:AddDropdown("MergeAnimals", {
        Text = "Filter Animals",
        Values = SylPhinCore.AnimalList,
        Default = {},
        Multi = true,
        Callback = function(Value) opt.MergeAnimals = Value end,
    })

    mergeBox:AddDropdown("MergeRarities", {
        Text = "Filter Rarity",
        Values = SylPhinCore.RarityLadder,
        Default = {},
        Multi = true,
        Callback = function(Value) opt.MergeRarities = Value end,
    })

    mergeBox:AddInput("MergeMinKg", {
        Default = "0",
        Numeric = true,
        Finished = false,
        Text = "Minimum KG",
        Placeholder = "0",
        Callback = function(Value)
            local num = tonumber(Value)
            opt.MergeMinKg = (num and num >= 0) and num or 0
        end,
    })

    mergeBox:AddInput("MergeBelowValue", {
        Default = "0",
        Numeric = false,
        Finished = false,
        Text = "Only Below $/s",
        Placeholder = "VD: 100K, 50M, 1B",
        Callback = function(Value) opt.MergeBelowValue = SylPhinCore.ParseFormat(Value) end,
    })

    local battleTab = Window:AddTab("Battle Mods", "swords", "Battle & Combat Mods")
    local combatBox = battleTab:AddLeftGroupbox("Combat", "crossed-swords")

    Toggle(combatBox, "KillAura", { 
        Text = "Kill Aura", 
        Tooltip = "Tự động vung gậy đánh người chơi xung quanh",
        Callback = function(v) State.Opt.KillAura = v end 
    })

    combatBox:AddSlider("AuraRange", {
        Text = "Aura Range",
        Default = 15,
        Min = 5,
        Max = 50,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(Value) State.Opt.AuraRange = Value end,
    })

    combatBox:AddSlider("AttackDelay", {
        Text = "Attack Delay",
        Default = 0.1,
        Min = 0.05,
        Max = 1,
        Rounding = 2,
        Suffix = "s",
        Callback = function(Value) State.Opt.AttackDelay = Value end,
    })

    Toggle(combatBox, "AntiHit", { 
        Text = "Anti Hit", 
        Tooltip = "Chống bị khống chế/choáng khi nhận đòn đánh",
        Callback = function(v) State.Opt.AntiHit = v end 
    })

    Toggle(combatBox, "AntiRagdoll", { 
        Text = "Anti Ragdoll", 
        Tooltip = "Chống té ngã khi bị đánh trúng",
        Callback = function(v) State.Opt.AntiRagdoll = v end 
    })

    local characterBox = battleTab:AddRightGroupbox("Character", "user")

    Toggle(characterBox, "InfJump", { 
        Text = "Infinite Jump", 
        Tooltip = "Cho phép nhảy liên tục không giới hạn trên không",
        Callback = function(v) State.Opt.InfJump = v end 
    })

    Toggle(characterBox, "AutoHitCarriers", { 
        Text = "Auto Hit Carriers", 
        Tooltip = "Hits players carrying an animal (needs Auto Steal)",
        Callback = function(v) 
            State.Opt.AutoHitCarriers = v 
            State.Opt.RobCarriers = v
        end 
    })

    local miscTab = Window:AddTab("Misc", "sliders", "Miscellaneous & Configs")
    local moveBox = miscTab:AddLeftGroupbox("Movement & Physics", "cpu")

    Toggle(moveBox, "EnableSpeed", { 
        Text = "Enable Speed",
        Callback = function(v)
            State.Opt.EnableSpeed = v
            if not v then
                local char, hum = SylPhinCore:Character()
                if hum and savedFarmedSpeed then
                    hum.WalkSpeed = savedFarmedSpeed
                    savedFarmedSpeed = nil
                end
            end
        end
    })
    moveBox:AddSlider("SpeedValue", { Text = "Speed Value", Default = 32, Min = 16, Max = 400, Rounding = 0, Callback = function(v) State.Opt.SpeedValue = v end })
    
    Toggle(moveBox, "Freecam", { 
       Text = "Freecam (Soul Mode)",
       Callback = function(v) ToggleSoulFreecam(v) end 
   })  

    moveBox:AddSlider("FreecamSpeed", { Text = "Freecam Speed", Default = 50, Min = 10, Max = 200, Rounding = 0, Callback = function(v) State.Opt.FreecamSpeed = v end })
    Toggle(moveBox, "InstantInteract", { Text = "Instant Interact" })
    Toggle(moveBox, "AntiAFK", { Text = "Anti AFK", Default = true })
    Toggle(moveBox, "NoGameplayPaused", { Text = "No Gameplay Paused", Default = true })
    Toggle(moveBox, "AutoReconnect", { Text = "Auto Reconnect" })

    Toggle(moveBox, "FPSBoost", { 
        Text = "FPS Boost",
        Callback = function(v)
            State.Opt.FPSBoost = v
            ToggleFPSBoost(v)
        end
    })

    Toggle(moveBox, "Disable3DRender", { 
        Text = "Disable 3D Render",
        Callback = function(v)
            State.Opt.Disable3DRender = v
            Update3DRender(v)
        end
    })

    moveBox:AddDropdown("BackgroundTheme", {
        Text = "Background",
        Values = { "Black", "Dark Purple", "Midnight", "Custom" },
        Default = 1,
        Callback = function(v)
            State.Opt.BackgroundTheme = v
            if State.Opt.Disable3DRender then Update3DRender(true) end
        end,
    })

    moveBox:AddButton("Join our discord server", function() JoinDiscord() end)

    local visualBox = miscTab:AddRightGroupbox("Visuals", "eye")

    Toggle(visualBox, "EggESP", { Text = "Egg ESP" })
    visualBox:AddDropdown("EggESPRarities", { Text = "Egg ESP Rarities", Values = SylPhinCore.RarityLadder, Default = {}, Multi = true, Callback = function(v) State.Opt.EggESPRarities = v end })
    Toggle(visualBox, "HatchPreview", { Text = "Hatch Preview", Default = true })
    Toggle(visualBox, "GuardESP", { Text = "Guard ESP" })

    local configBox = miscTab:AddRightGroupbox("Configuration", "settings")

    configBox:AddInput("ConfigNameInput", {
        Default = "",
        Numeric = false,
        Finished = true,
        Text = "Config name",
        Placeholder = "Type config name...",
        Callback = function(v) State.Opt.ConfigName = v end
    })

    local configDropdown = configBox:AddDropdown("ConfigList", {
        Text = "Config list",
        Values = ConfigSystem.GetList(),
        Default = 1,
        Callback = function(v) 
            if type(v) == "number" then
                local list = ConfigSystem.GetList()
                State.Opt.SelectedConfig = list[v] or "Default"
            else
                State.Opt.SelectedConfig = tostring(v)
            end
        end,
    })

    local function RefreshDropdown()
        local list = ConfigSystem.GetList()
        configDropdown:SetValues(list)
    end

    configBox:AddButton("Create config", function()
        local name = State.Opt.ConfigName
        if name and name ~= "" then
            ConfigSystem.Save(name)
            RefreshDropdown()
            configDropdown:SetValue(name)
            State.Opt.SelectedConfig = name
        end
    end)

    configBox:AddButton("Load config", function()
        local selected = State.Opt.SelectedConfig or "Default"
        ConfigSystem.Load(selected, Library)
    end)

    configBox:AddButton("Overwrite config", function()
        local selected = State.Opt.SelectedConfig or "Default"
        ConfigSystem.Save(selected)
    end)

    configBox:AddButton("Delete config", function()
        local selected = State.Opt.SelectedConfig or "Default"
        ConfigSystem.Delete(selected)
        RefreshDropdown()
        configDropdown:SetValue("Default")
    end)

    configBox:AddButton("Refresh list", function() RefreshDropdown() end)

    local autoloadLabel = configBox:AddLabel("Current autoload config: " .. (State.Opt.CurrentAutoload or "Default"))

    configBox:AddButton("Set as autoload", function()
        local selected = State.Opt.SelectedConfig or "Default"
        State.Opt.CurrentAutoload = selected
        ConfigSystem.Save("_Autoload_")
        autoloadLabel:SetText("Current autoload config: " .. selected)
    end)

    configBox:AddButton("Reset autoload", function()
        State.Opt.CurrentAutoload = "Default"
        ConfigSystem.Delete("_Autoload_")
        autoloadLabel:SetText("Current autoload config: Default")
    end)

    Toggle(configBox, "AutoLoadConfig", { 
        Text = "Auto Load", 
        Default = false,
        Callback = function(v) State.Opt.AutoLoadConfig = v end
    })

    Toggle(configBox, "AutoSaveConfig", { Text = "Auto Save", Default = true })

    configBox:AddButton("Reset to Defaults", function()
        ConfigSystem.Load("Default", Library)
    end)

    task.spawn(function()
        task.wait(0.5)
        if isfile and isfile(CONFIG_FOLDER .. "/_Autoload_.json") then
            local rawData = readfile(CONFIG_FOLDER .. "/_Autoload_.json")
            local ok, parsed = pcall(function() return HttpService:JSONDecode(rawData) end)
            if ok and type(parsed) == "table" then
                if parsed.AutoLoadConfig == true then
                    ConfigSystem.Load("_Autoload_", Library)
                    if State.Opt.CurrentAutoload then
                        autoloadLabel:SetText("Current autoload config: " .. tostring(State.Opt.CurrentAutoload))
                    end
                else
                    if parsed.CurrentAutoload then
                        autoloadLabel:SetText("Current autoload config: " .. tostring(parsed.CurrentAutoload))
                    end
                end
            end
        end
    end)
end

pcall(SylPhinBanner.Step, "Systems")
BuildInterface()

if type(SylPhinCore.Scheduler) == "table" then
    if type(SylPhinCore.Scheduler.Side) == "function" then
        task.spawn(function() pcall(SylPhinCore.Scheduler.Side) end)
    end
    if type(SylPhinCore.Scheduler.Init) == "function" then
        pcall(SylPhinCore.Scheduler.Init)
    elseif type(SylPhinCore.Scheduler.Start) == "function" then
        pcall(SylPhinCore.Scheduler.Start)
    end
end

pcall(SylPhinBanner.Step, "Interface")
pcall(SylPhinBanner.Ready)
