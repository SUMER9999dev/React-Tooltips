local React = require(script.Parent.React)


local function useMouse(): Mouse
    return React.useMemo(function()
        return game.Players.LocalPlayer:GetMouse()
    end, {})
end


return useMouse