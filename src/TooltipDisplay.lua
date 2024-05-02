local React = require(script.Parent.Parent.react)

local Context = require(script.Parent.Context)
local Alignments = require(script.Parent.Alignments)

local useMouse = require(script.Parent.useMouse)
local useSignal = require(script.Parent.useSignal)

local types = require(script.Parent.types)


local function create_tooltip_mapper(tooltip: types.Tooltip): (vectors: {Vector2}) -> UDim2
    return function(vectors: {Vector2}): UDim2
        local display_absolute_position = vectors[1]
        local mouse_absolute_position = vectors[2]

        local tooltip_absolute_position = vectors[3]

        local tooltip_absolute_size = vectors[4]

        if tooltip.follow_cursor then
            return UDim2.fromOffset(
                math.abs(display_absolute_position.X - mouse_absolute_position.X),
                math.abs(display_absolute_position.Y - mouse_absolute_position.Y)
            )
        end

        if not tooltip.alignment then
            error('If the follow cursor is disabled, then you need to specify alignment')
        end

        return Alignments[tooltip.alignment](tooltip_absolute_size, tooltip_absolute_position)
    end
end


return function(props: {ZIndex: number})
    local tooltip_context = React.useContext(Context)
    local tooltip: types.Tooltip?, set_tooltip = React.useState(nil :: types.Tooltip?)
    
    local mouse = useMouse()

    local absolute_position, set_absolute_position = React.useBinding(Vector2.zero)
    local mouse_position, set_mouse_position = React.useBinding(Vector2.zero)

    if not tooltip_context then
        error('Failed to get ReactTooltips.Context, ReactTooltips.Display must be used inside ReactTooltips.Provider') 
    end

    React.useEffect(function()
        local cleanup = tooltip_context.on_tooltip_changed(function(new_tooltip: types.Tooltip?)
            set_tooltip(new_tooltip)
        end)

        return cleanup
    end, {})

    useSignal(mouse.Move, function()
        set_mouse_position(Vector2.new(mouse.X, mouse.Y))
    end)

    return React.createElement(
        'Frame',

        {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromOffset(1, 1),  -- React-Lua will not fire React.Change.AbsolutePosition without that
            BackgroundTransparency = 1,
            ZIndex = props.ZIndex or 9999,

            [React.Change.AbsolutePosition] = function(rbx: Frame)
                set_absolute_position(rbx.AbsolutePosition)
            end
        },

        if tooltip then React.createElement(tooltip.component, {
            position = React.joinBindings(
                { absolute_position, mouse_position, tooltip.absolute_position, tooltip.absolute_size }
            ):map(create_tooltip_mapper(tooltip)),

            tooltip = tooltip
        }) else nil
    )
end
