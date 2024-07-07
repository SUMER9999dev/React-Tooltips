local React = require(script.Parent.React)

local useTooltip = require(script.Parent.useTooltip)
local types = require(script.Parent.types)


type props = {
    appear_delay: number?,
    follow_cursor: boolean?,
    alignment: types.Alignment?,

    component: React.ComponentType<{
        position: React.Binding<UDim2>,
        tooltip: types.Tooltip
    }>,

	props: {[string]: any}?
}


local function Tooltip(props: props)
    local update_absolute_position, update_absolute_size, mouse_enter, mouse_leave = useTooltip(props)

    return React.createElement('Frame', {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        [React.Change.AbsoluteSize] = update_absolute_size,
        [React.Change.AbsolutePosition] = update_absolute_position,

        [React.Event.MouseEnter] = mouse_enter,
        [React.Event.MouseLeave] = mouse_leave
    })
end


return Tooltip :: React.ComponentType<props>