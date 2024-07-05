local React = require(script.Parent.React)


function useSignal(signal: RBXScriptSignal, callback: (...any) -> (), dependencies: {any}?)
	React.useEffect(function()
		local connection = signal:Connect(callback)

		return function()
			connection:Disconnect()
		end
	end, dependencies or {signal})
end


return useSignal
