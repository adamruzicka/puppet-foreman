# @summary Register the host as foreman
# @api private
class foreman::register {
  if $foreman::register_in_foreman {
    foreman_host { $foreman::servername:
      ensure          => present,
      base_url        => $foreman::foreman_url,
      consumer_key    => $foreman::oauth_consumer_key,
      consumer_secret => $foreman::oauth_consumer_secret,
      effective_user  => $foreman::oauth_effective_user,
      ssl_ca          => $foreman::server_ssl_ca,
    }

    foreman_instance_host { $foreman::servername:
      ensure          => present,
      base_url        => $foreman::foreman_url,
      consumer_key    => $foreman::oauth_consumer_key,
      consumer_secret => $foreman::oauth_consumer_secret,
      effective_user  => $foreman::oauth_effective_user,
      ssl_ca          => $foreman::server_ssl_ca,
      require         => $foreman_host[$foreman::servername],
    }
  }
}
