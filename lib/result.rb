class Result
  def initialize(status:, id: nil, errors: nil, resource: nil, resources: nil)
    @status = status
    @id = id
    @errors = errors.to_a
    @resource = resource
    @resources = resources
  end

  attr_reader :status, :id, :errors, :resource, :resources
end
