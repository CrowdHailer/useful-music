require "scorched/rest/version"

module Scorched
  module Rest
    ActionNotImplemented = Class.new(StandardError)

    def self.included(klass)
      klass.get('/') { send :index }
      klass.get('/new') { send :new }
      klass.post('/') { send :create }
      klass.get('/:id') { |id| send :show, id }
      klass.get('/:id/edit') { |id| send :edit, id }
      klass.route('/:id', method: ['PATCH', 'PUT']) { |id| send :update, id }
      klass.delete('/:id') { |id| send :destroy, id }
    end

    def index
      raise ActionNotImplemented.new("Controller is missing index action")
    end

    def new
      raise ActionNotImplemented.new("Controller is missing new action")
    end

    def create
      raise ActionNotImplemented.new("Controller is missing create action")
    end

    def show(id)
      raise ActionNotImplemented.new("Controller is missing show action")
    end

    def edit(id)
      raise ActionNotImplemented.new("Controller is missing edit action")
    end

    def update(id)
      raise ActionNotImplemented.new("Controller is missing update action")
    end

    def destroy(id)
      raise ActionNotImplemented.new("Controller is missing destroy action")
    end
  end
end
