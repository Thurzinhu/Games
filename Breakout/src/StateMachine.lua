StateMachine = Class{}

function StateMachine:init(states)
    -- empty state 
    self.empty = {
        render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
    }
    self.current = self.empty
    self.states = states or {}
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) -- ensuring state exists
    self.current:exit() -- exiting current state
    self.current = self.states[stateName]() -- changing current state
    self.current:enter(enterParams) -- entering new state
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end