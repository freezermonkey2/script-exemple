--[[
    Hidden Developer Application Script
    Author: Jacob
    Description:
        This script implements a small but complete "Daily Task" system.
        It demonstrates:
        ✦ Clean structure & separation of concerns
        ✦ Use of Roblox services & RemoteEvents
        ✦ Defensive programming (pcall, validation, debouncing)
        ✦ Type annotations (Luau)
        ✦ Clear comments & documentation
--]]

--// Services
local Players: Players = game:GetService("Players")
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService: RunService = game:GetService("RunService")

--// Remote setup (created at runtime so the script is self-contained)
local RemotesFolder: Folder = ReplicatedStorage:FindFirstChild("DailyTaskRemotes") or Instance.new("Folder")
RemotesFolder.Name = "DailyTaskRemotes"
RemotesFolder.Parent = ReplicatedStorage

local TaskRequestEvent: RemoteEvent = RemotesFolder:FindFirstChild("RequestTasks") :: RemoteEvent
if not TaskRequestEvent then
    TaskRequestEvent = Instance.new("RemoteEvent")
    TaskRequestEvent.Name = "RequestTasks"
    TaskRequestEvent.Parent = RemotesFolder
end

local TaskCompleteEvent: RemoteEvent = RemotesFolder:FindFirstChild("CompleteTask") :: RemoteEvent
if not TaskCompleteEvent then
    TaskCompleteEvent = Instance.new("RemoteEvent")
    TaskCompleteEvent.Name = "CompleteTask"
    TaskCompleteEvent.Parent = RemotesFolder
end

local TaskUpdateEvent: RemoteEvent = RemotesFolder:FindFirstChild("TaskUpdate") :: RemoteEvent
if not TaskUpdateEvent then
    TaskUpdateEvent = Instance.new("RemoteEvent")
    TaskUpdateEvent.Name = "TaskUpdate"
    TaskUpdateEvent.Parent = RemotesFolder
end

--// Type definitions
type TaskId = string

type TaskDefinition = {
    Id: TaskId,
    DisplayName: string,
    Description: string,
    Goal: number,
    RewardCoins: number,
}

type PlayerTaskState = {
    Progress: number,
    Completed: boolean,
}

type PlayerTaskData = {
    Tasks: {[TaskId]: PlayerTaskState},
    LastReset: number,
}

--// Configuration
local DAILY_RESET_INTERVAL: number = 60 * 60 * 24 -- 24 hours in seconds
local AUTO_SAVE_INTERVAL: number = 60 -- seconds

local TASK_DEFINITIONS: {TaskDefinition} = {
    {
        Id = "collect_coins",
        DisplayName = "Coin Collector",
        Description = "Collect 25 coins around the map.",
        Goal = 25,
        RewardCoins = 50,
    },
    {
        Id = "walk_distance",
        DisplayName = "Explorer",
        Description = "Walk 500 studs in the world.",
        Goal = 500,
        RewardCoins = 75,
    },
    {
        Id = "play_time",
        DisplayName = "Dedicated Player",
        Description = "Stay in the game for 10 minutes.",
        Goal = 600,
        RewardCoins = 100,
    },
}

--// Utility: quick lookup table for tasks by Id
local TaskById: {[TaskId]: TaskDefinition} = {}
for _, def in ipairs(TASK_DEFINITIONS) do
    TaskById[def.Id] = def
end

--// Player data store (in-memory for demo; could be wired to DataStoreService)
local PlayerTaskStore: {[Player] : PlayerTaskData} = {}

--// Simple coin reward event (for demo only)
local CoinRewardEvent: BindableEvent = Instance.new("BindableEvent")
CoinRewardEvent.Name = "CoinRewardEvent"

--[[
    Initializes a player's daily tasks.
    If they already have data and it's not expired, reuse it.
    Otherwise, reset tasks.
--]]
local function initializePlayerData(player: Player)
    local now: number = os.time()
    local existing: PlayerTaskData? = PlayerTaskStore[player]

    if existing and (now - existing.LastReset) < DAILY_RESET_INTERVAL then
        -- Data is still valid; keep it
        return
    end

    local newData: PlayerTaskData = {
        Tasks = {},
        LastReset = now,
    }

    for _, def in ipairs(TASK_DEFINITIONS) do
        newData.Tasks[def.Id] = {
            Progress = 0,
            Completed = false,
        }
    end

    PlayerTaskStore[player] = newData
end

--[[
    Safely gets a player's task data.
    Returns nil if not initialized (should not happen if we call initializePlayerData).
--]]
local function getPlayerData(player: Player): PlayerTaskData?
    return PlayerTaskStore[player]
end

--[[
    Sends the current task state to the client.
    This is used when the player opens the Daily Task UI.
--]]
local function sendTasksToClient(player: Player)
    local data: PlayerTaskData? = getPlayerData(player)
    if not data then
        return
    end

    -- Build a serializable table for the client
    local payload = {
        LastReset = data.LastReset,
        Tasks = {},
    }

    for id, state in pairs(data.Tasks) do
        local def: TaskDefinition? = TaskById[id]
        if def then
            table.insert(payload.Tasks, {
                Id = id,
                DisplayName = def.DisplayName,
                Description = def.Description,
                Goal = def.Goal,
                Progress = state.Progress,
                Completed = state.Completed,
                RewardCoins = def.RewardCoins,
            })
        end
    end

    TaskUpdateEvent:FireClient(player, payload)
end

--[[
    Increments progress for a given task.
    Handles completion, rewards, and client updates.
--]]
local function incrementTaskProgress(player: Player, taskId: TaskId, amount: number)
    local data: PlayerTaskData? = getPlayerData(player)
    if not data then
        return
    end

    local state: PlayerTaskState? = data.Tasks[taskId]
    local def: TaskDefinition? = TaskById[taskId]

    if not state or not def then
        return
    end

    if state.Completed then
        return -- already done
    end

    state.Progress += amount

    if state.Progress >= def.Goal then
        state.Progress = def.Goal
        state.Completed = true

        -- Reward the player (BindableEvent so this system is decoupled)
        CoinRewardEvent:Fire(player, def.RewardCoins)
    end

    sendTasksToClient(player)
end
