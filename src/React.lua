local Packages = script.Parent.Parent

Packages = if Packages:FindFirstChild('React') then Packages else Packages:FindFirstChild('ReactLua')
assert(Packages, 'Failed to find packages.')

local React = Packages:FindFirstChild('React')
assert(React, 'Failed to find react dependency.')

local ReactLibrary = require(React)

export type ComponentType<T> = typeof((function()
	local React = require(script.Parent.Parent.React)
	return ({} :: any) :: React.ComponentType<T>
end)())

export type Binding<T> = typeof((function()
	local React = require(script.Parent.Parent.React)
	return {} :: React.Binding<T>
end)())

return ReactLibrary
