local React = require(script.Parent.Parent.react)


function useSignal(signal: RBXScriptSignal, callback: (...any) -> ())
	React.useEffect(function()
		local connection = signal:Connect(callback)

		return function()
			connection:Disconnect()
		end
	end, {signal})
end


return useSignal
