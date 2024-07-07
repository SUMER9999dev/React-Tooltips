local React = require(script.Parent.React)


return function<T>(value: T): T
	local ref = React.useRef((nil :: any) :: T)
	local previous = ref.current

	ref.current = value

	return previous
end