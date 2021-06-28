Puppet::Type.type(:foreman_instance_host).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_resource).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def exists?
    return false if host.nil?

    host['foreman']
  end

  def create
    if host.nil?
      error_string = "Host #{resource[:name]} does not exist in Foreman at #{request_uri('')}"
      raise Puppet::Error.new(error_string)
    end

    path = "api/v2/instance/hosts/#{id}"
    r = request(:put, path, {})

    unless success?(r)
      error_string = "Error making PUT request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def destroy
    path = "api/v2/instance/hosts/#{id}"
    r = request(:delete, path, {})

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
end
