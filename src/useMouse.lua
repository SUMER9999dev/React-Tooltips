local React = require(game.ReplicatedStorage.Packages.react)


local function useMouse(): Mouse
    return React.useMemo(function()
        return game.Players.LocalPlayer:GetMouse()
    end, {})
end


return useMouse