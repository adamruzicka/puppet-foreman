Puppet::Type.type(:foreman_host).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_resource).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def exists?
    !id.nil?
  end

  def create
    path = "api/v2/hosts/facts"
    payload = {
      :name => resource[:name],
      :certname => resource[:name],
      :facts => resource[:facts]
    }
    r = request(:post, path, {}, payload.to_json)

    unless success?(r)
      error_string = "Error making POST request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def destroy
    r = request(:delete, destroy_path, {})

    unless success?(r)
      error_string = "Error making DELETE request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def id
    host['id'] if host
  end

  def host
    @host ||= begin
      path = 'api/v2/hosts'
      r = request(:get, path, :search => %{name="#{resource[:name]}"})

      unless success?(r)
        error_string = "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(r)}"
        raise Puppet::Error.new(error_string)
      end

      JSON.load(r.body)['results'].first
    end
  end

  private

  def destroy_path
    "api/v2/hosts/#{id}"
  end
end
