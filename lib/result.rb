class Result
  def initialize(status:, id: nil, errors: nil)
    @status = status
    @id = id
    @errors = errors.to_a
  end

  attr_reader :status, :id, :errors
end
