module RequestHelpers
  def get(path, **args)
    process(:get, path, **args)
  end

  def post(path, **args)
    process(:post, path, **args)
  end

  def patch(path, **args)
    process(:patch, path, **args)
  end

  def put(path, **args)
    process(:put, path, **args)
  end

  def delete(path, **args)
    process(:delete, path, **args)
  end

  def head(path, *args)
    process(:head, path, *args)
  end

  def process(method, path, headers: nil, **args)
    result = super(method, path, headers: headers, **args)

    if response.content_type =~ /application\/json/
      JSON.parse(response.body)
    else
      result
    end
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
