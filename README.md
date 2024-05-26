# 🏷 React-Tooltips
This library is created to display different hints when hovering over elements, created specially for React-Lua

# ☄️ Installation

## Wally
``react-tooltips = "sumer9999dev/react-tooltips@1.0.4"``

## TypeScript
Use this port https://github.com/Tesmi-Develop/react-tooltips-ts

# 📚 Documentation

## Provider
First thing you need is creating Tooltip provider

```lua
React.createElement(ReactTooltips.Provider, nil, {
    ...
})
```

## Display

Now you need to create display to display hints

```lua
React.createElement(ReactTooltips.Provider, nil, {
    display = React.createElement(ReactTooltips.Display, {ZIndex = 9999})
})
```

ZIndex is optional, so you don't have to specify it.

## Tooltip

Now you can create tooltips!

But first you need to create hint element, that will display on hover

```lua
local function hint(props: {position: React.Binding<UDim2>})
	local state, set_state = React.useState(1)

	React.useEffect(function()
		local connection = game.UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				set_state(state + 1)
			end
		end)

		return function()
			connection:Disconnect()
		end		
	end, {state})

	return React.createElement('TextLabel', {
		Position = props.position,

		Size = UDim2.fromScale(0.1, 0.1),
		Text = `Hello, {state}!`
	})
end
```

First way to create tooltip, is to create hitbox

```lua
React.createElement(ReactTooltips.Provider, nil, {
    display = React.createElement(ReactTooltips.Display, {ZIndex = 9999}),
    
    image = React.createElement('ImageLabel', {
        AnchorPoint = Vector2.new(0.5, 0.5),

        Size = UDim2.fromScale(0.25, 0.25),
        Position = UDim2.fromScale(0.5, 0.5),

        Image = 'asset'
    }, {
        tooltip = React.createElement(ReactTooltips.Tooltip, {
            follow_cursor = false,  -- alignment will not work if follow_cursor enabled
            alignment = 'Right',  -- Left | Right | Bottom | Top, you need to set alignment or follow_cursor

            appear_delay = 1,  -- optional, appear delay in seconds, will display only after hovering for 1 second

            component = hint  -- here you need to put hint component
        })
    })
})
```

Second way is using ``useTooltip`` hook, that allow more flexability

```lua
local function image_tooltip()
    local update_absolute_position, update_absolute_size, mouse_enter, mouse_leave = ReactTooltips.useTooltip({
            follow_cursor = false,  -- alignment will not work if follow_cursor enabled
            alignment = 'Right',  -- Left | Right | Bottom | Top, you need to set alignment or follow_cursor

            appear_delay = 1,  -- optional, appear delay in seconds, will display only after hovering for 1 second

            component = hint  -- here you need to put hint component
    })

    return React.createElement('ImageLabel', {
        AnchorPoint = Vector2.new(0.5, 0.5),

        Size = UDim2.fromScale(0.25, 0.25),
        Position = UDim2.fromScale(0.5, 0.5),

        Image = 'asset',

        [React.Change.AbsolutePosition] = update_absolute_position,
        [React.Change.AbsoluteSize] = update_absolute_size,

        [React.Event.MouseEnter] = mouse_enter,
        [React.Event.MouseLeave] = mouse_leave
    })
end

React.createElement(ReactTooltips.Provider, nil, {
    display = React.createElement(ReactTooltips.Display, {ZIndex = 9999}),
    image = React.createElement(image_tooltip)
})
```

# ❤️ Credits
SUMER (Discord: sumer_real) - library

Tesmi (Discord: tesmi) - typescript port
