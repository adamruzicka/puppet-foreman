Puppet::Type.newtype(:foreman_host) do
  desc 'foreman_host creates a host in foreman.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the host.'
  end

  newparam(:facts) do
    desc 'Hash of facts about the host'

    defaultto { $facts }
  end

  newparam(:base_url) do
    desc 'Foreman\'s base url.'
  end

  newparam(:effective_user) do
    desc 'Foreman\'s effective user for the registration (usually admin).'
  end

  newparam(:consumer_key) do
    desc 'Foreman oauth consumer_key'
  end

  newparam(:consumer_secret) do
    desc 'Foreman oauth consumer_secret'
  end

  newparam(:ssl_ca) do
    desc 'Foreman SSL CA (certificate authority) for verification'
  end

  newparam(:timeout) do
    desc "Timeout for HTTP(s) requests"

    munge do |value|
      value = value.shift if value.is_a?(Array)
      begin
        value = Integer(value)
      rescue ArgumentError
        raise ArgumentError, "The timeout must be a number.", $!.backtrace
      end
      [value, 0].max
    end

    defaultto 500
  end

  autorequire(:anchor) do
    ['foreman::service']
  end
end
