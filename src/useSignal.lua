local React = require(script.Parent.React)


function useSignal(signal: RBXScriptSignal, callback: (...any) -> ())
	React.useEffect(function()
		local connection = signal:Connect(callback)

		return function()
			connection:Disconnect()
		end
	end, {signal})
end


return useSignal
