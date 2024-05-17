StateMachine = Class{}

function StateMachine:init(states)
    local default = {
        enter = function() end,
        update = function() end,
        exit = function() end,
        render = function() end
    }
    self.currentState = default
    self.states = states or {}
end

function StateMachine:change(state, params)
    assert(self.states[state])
    self.currentState:exit()
    self.currentState = self.states[state]()
    self.currentState:enter(params)
end

function StateMachine:update(dt)
    self.currentState:update(dt)
end

function StateMachine:render()
    self.currentState:render()
end