local React = require(script.Parent.React)
local Context = require(script.Parent.Context)

local useSignal = require(script.Parent.useSignal)
local useMouse = require(script.Parent.useMouse)

local types = require(script.Parent.types)


type TooltipConfiguration = {
    appear_delay: number?,
    follow_cursor: boolean?,
    alignment: types.Alignment?,

    component: React.ComponentType<{
        position: React.Binding<UDim2>,
        tooltip: types.Tooltip
    }>
}


local RunService = game:GetService('RunService')


local function useTooltip(config: TooltipConfiguration)
    local tooltip_context = React.useContext(Context)

    if not tooltip_context then
        error('Failed to get ReactTooltips.Context, ReactTooltips.useTooltip must be used inside ReactTooltips.Provider') 
    end

    local absolute_position, set_absolute_position = React.useBinding(Vector2.zero)
    local absolute_size, set_absolute_size = React.useBinding(Vector2.zero)

    local appear_thread = React.useRef((nil :: any) :: thread)
    local is_enabled = React.useRef(false)

    local mouse = useMouse()

    local tooltip: types.Tooltip = React.useMemo(function()
        return {
            appear_delay = config.appear_delay,
            follow_cursor = config.follow_cursor,
            alignment = config.alignment,

            absolute_size = absolute_size,
            absolute_position = absolute_position,

            component = config.component
        }
    end, {config.appear_delay or 0, config.follow_cursor or 'nil', config.alignment or 'nil', config.component})

    local update_absolute_size = React.useCallback(function(rbx: GuiBase2d)
        set_absolute_size(rbx.AbsoluteSize)
    end, {})

    local update_absolute_position = React.useCallback(function(rbx: GuiBase2d)
        set_absolute_position(rbx.AbsolutePosition)
    end, {})

    local mouse_enter = React.useCallback(function()
        if appear_thread.current then
            task.cancel(appear_thread.current)
        end

        appear_thread.current = task.delay(tooltip.appear_delay or 0, function()
            tooltip_context.change_tooltip(tooltip)
        end)
    end, {tooltip})

    local mouse_leave = React.useCallback(function()
        if not is_enabled.current then
            return
        end

        if appear_thread.current then
            task.cancel(appear_thread.current)
            appear_thread.current = nil
        end

        tooltip_context.change_tooltip(nil)
    end, {tooltip})

    React.useEffect(function()
        local cleanup = tooltip_context.on_tooltip_changed(function(new_tooltip)
            is_enabled.current = new_tooltip == tooltip
        end)

        return cleanup
    end, {tooltip})

    useSignal(RunService.Heartbeat, function()
        if not is_enabled.current then
            return
        end

        local position = absolute_position:getValue()
        local size = absolute_size:getValue()

        if position.X + size.X < mouse.X then
            mouse_leave()
            return
        end

        if position.X > mouse.X then
            mouse_leave()
            return
        end

        if position.Y + size.Y < mouse.Y then
            mouse_leave()
            return
        end

        if position.Y > mouse.Y then
            mouse_leave()
            return
        end
    end)

    return update_absolute_position, update_absolute_size, mouse_enter, mouse_leave
end


return useTooltip
