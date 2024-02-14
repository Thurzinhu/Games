StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        enter = function() end,
        exit = function() end,
        update = function() end,
        render = function() end
    }

    self.states = states or {}
    --[[
        self.states contains a table where each key is related to a function
        that returns a state

        In order to change the current state we are in we just need to access the key 
        state and then call the function
    ]]
    self.current = self.empty
end

function StateMachine:change(state, enterParams)
    assert(self.states[state]) -- asserting state exists
    self.current:exit()
    self.current = self.states[state]() 
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end