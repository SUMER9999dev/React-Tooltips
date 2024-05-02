local types = require(script.Parent.types)


return {
    Right = function(size: Vector2, position: Vector2)
        return UDim2.fromOffset(
            position.X + size.X,
            position.Y + (size.Y / 2)
        )
    end,

    Left = function(size: Vector2, position: Vector2)
        return UDim2.fromOffset(
            position.X,
            position.Y + (size.Y / 2)
        )
    end,

    Top = function(size: Vector2, position: Vector2)
        return UDim2.fromOffset(
            position.X + (size.X / 2),
            position.Y
        )
    end,

    Bottom = function(size: Vector2, position: Vector2)
        return UDim2.fromOffset(
            position.X + (size.X / 2),
            position.Y + size.Y
        )
    end
} :: {[types.Alignment]: (size: Vector2, position: Vector2) -> UDim2}
