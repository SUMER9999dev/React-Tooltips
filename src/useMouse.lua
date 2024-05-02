local React = require(script.Parent.Parent.react)


local function useMouse(): Mouse
    return React.useMemo(function()
        return game.Players.LocalPlayer:GetMouse()
    end, {})
end


return useMouse