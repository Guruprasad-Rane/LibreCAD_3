DimRadialOperations = {}
DimRadialOperations.__index = DimRadialOperations

setmetatable(DimRadialOperations, {
    __index = CreateOperations,
    __call = function (o, ...)
        local self = setmetatable({}, o)
        self:_init(...)
        return self
    end,
})

function DimRadialOperations:init()
   	mainWindow:connectMenuItem("actionRadius", function() run_basic_operation(DimRadialOperations) end)

    mainWindow:getCliCommand():addCommand("DIMRADIAL", function() run_basic_operation(DimRadialOperations) end)
end

function DimRadialOperations:_init()
    CreateOperations._init(self, lc.builder.DimRadialBuilder, "enterStartPoint")

    message("Click on first definition point")
end

function DimRadialOperations:enterStartPoint(eventName, data)
    if(eventName == "mouseMove" or eventName == "point") then
        self.builder:setDefinitionPoint(data["position"])
    end

    if(eventName == "point") then
        self.step = "enterEndPoint"

        message("Click on end point")
    end
end

function DimRadialOperations:enterEndPoint(eventName, data)
    if(eventName == "mouseMove" or eventName == "point") then
        self.builder:setDefinitionPoint2(data["position"])
    end

    if(eventName == "point") then
        self.step = "enterMiddleOfText"

        message("Click on text position")
    end
end

function DimRadialOperations:enterMiddleOfText(eventName, data)
    if(eventName == "mouseMove" or eventName == "point") then
        self.builder:setMiddleOfText(data["position"])
    end

    if(eventName == "point") then
        self.step = "enterText"

        mainWindow:getCliCommand():returnText( true)

        message("Enter dimension text (<> for value)")
    end
end

function DimRadialOperations:enterText(eventName, data)
    if(eventName == "text") then
        mainWindow:getCliCommand():returnText( false)
        self.builder:setExplicitValue(data["text"])
        self:createEntity()
    end
end
