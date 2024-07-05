local React = require(script.Parent.React)
local Context = require(script.Parent.Context)

local types = require(script.Parent.types)


return function(props: {children: any})
    local changed_hooks = React.useRef((nil :: any) :: { (tooltip: types.Tooltip?) -> () })

    if not changed_hooks.current then
        changed_hooks.current = {}
    end

    local change_tooltip = React.useCallback(function(tooltip: types.Tooltip?)
        for _, hook in changed_hooks.current do
            hook(tooltip)
        end
    end, {})

    local on_tooltip_changed = React.useCallback(function(handler: (tooltip: types.Tooltip?) -> ())
        table.insert(changed_hooks.current, 1, handler)

        return function()
            local index = table.find(changed_hooks.current, handler)

            if not index then
                return
            end

            table.remove(changed_hooks.current, index)
        end
    end, {})

    local tooltip_context: types.TooltipContext = React.useMemo(function()
        return {
            change_tooltip = change_tooltip,
            on_tooltip_changed = on_tooltip_changed
        }
    end, {})

    return React.createElement(Context.Provider, {
        value = tooltip_context
    }, props.children)
end
