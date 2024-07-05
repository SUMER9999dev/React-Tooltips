local Packages = script.Parent.Parent
local React = Packages:FindFirstChild('React')

assert(React, 'Failed to find react dependency.')


local ReactLibrary = require(React)

export type ComponentType<T> = ReactLibrary.ComponentType<T>
export type Binding<T> = ReactLibrary.Binding<T>

return ReactLibrary
