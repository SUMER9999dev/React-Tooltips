local React = require(script.Parent.React)
local Context = require(script.Parent.Context)

local useSignal = require(script.Parent.useSignal)
local useMouse = require(script.Parent.useMouse)
local usePrevious = require(script.Parent.usePrevious)

local DeepEqual = require(script.Parent.DeepEqual)

local types = require(script.Parent.types)


type TooltipConfiguration = {
    appear_delay: number?,
    follow_cursor: boolean?,
    alignment: types.Alignment?,

    component: React.ComponentType<{
        position: React.Binding<UDim2>,
        tooltip: types.Tooltip
    }>,

	props: {[string]: any}?
}


local RunService = game:GetService('RunService')


local function optional_dependency<T>(value: T?): T | 'nil'
	return if value == nil then 'nil' else value
end 


local function useTooltip(config: TooltipConfiguration)
    local tooltip_context = React.useContext(Context)

    if not tooltip_context then
        error('Failed to get ReactTooltips.Context, ReactTooltips.useTooltip must be used inside ReactTooltips.Provider') 
    end

	assert(config.props == nil or typeof(config.props) == 'table', 'Tooltip props must be table or nil')

    local absolute_position, set_absolute_position = React.useBinding(Vector2.zero)
    local absolute_size, set_absolute_size = React.useBinding(Vector2.zero)

    local appear_thread = React.useRef((nil :: any) :: thread)
    local is_enabled = React.useRef(false)
	local previous_props = usePrevious(config.props)

    local mouse = useMouse()

    local tooltip: types.Tooltip = React.useMemo(function()
        return {
            appear_delay = config.appear_delay,
            follow_cursor = config.follow_cursor,
            alignment = config.alignment,

            absolute_size = absolute_size,
            absolute_position = absolute_position,

            component = config.component,

			props = config.props
        }
    end, {
		optional_dependency(config.appear_delay),
		optional_dependency(config.follow_cursor),
		optional_dependency(config.alignment),
		config.component,

		if DeepEqual(previous_props, config.props) then
			optional_dependency(previous_props) 
		else 
			optional_dependency(config.props)
	})

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
        if appear_thread.current then
            task.cancel(appear_thread.current)
            appear_thread.current = nil
        end

		if is_enabled.current then
        	tooltip_context.change_tooltip(nil)
		end
    end, {tooltip})

    React.useEffect(function()
		if is_enabled.current then
			tooltip_context.change_tooltip(tooltip)
		end

        local cleanup = tooltip_context.on_tooltip_changed(function(new_tooltip)
            is_enabled.current = new_tooltip == tooltip
        end)

        return cleanup
    end, {tooltip})

	React.useEffect(function()
		return function()
			if is_enabled.current then
				tooltip_context.change_tooltip(nil)
			end
		end
	end, {})

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
    end, {mouse_leave, mouse_enter})

    return update_absolute_position, update_absolute_size, mouse_enter, mouse_leave
end


return useTooltip
