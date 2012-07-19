## SSH port-forward only and Savon config

This is a quick hackup of a nice way to allow our Heroku application
Vorlesungsverzeichnis to access the web service it depends on. The idea:

1. Heroku gets a unique SSH key
2. One of our intranet accounts is configured to allow SSH connections via
   this key via the `authorized_keys` file. This is not a security problem
   because we can disallow the execution of commands and arbitrary port forwards.
   We only allow exactly one thing: to access one single host:port combination.
3. A standalone Ruby application based on `Net::SSH` runs on Heroku with the
   sole purpose of tunneling our port via SSH
4. Savon is configured to access the web service through that local forward.
   This is a bit tricky because we need to set the correct `Host` header and
   rewrite URLs from the WSDL that point to the original host name of the
   service.

### Files and directories

* `ssh_tunnel_client.rb`: The SSH tunnel client
* `savon.rb`: Example Ruby script to show how Savon has to be configured to
  access the tunneled service
* `example-dotssh`: An example `~/.ssh` directory showing off the SSH config

### Installation

1. On the tunnel server (probably an ATIS shell server), create a new SSH
   client key: `ssh-keygen -b 4096`
2. Use the provided `~/.ssh` example directory as a basis and add the new key
   to the `authorized_keys` file with the config shown in the example
3. Deploy the `ssh_tunnel_client.rb` app to Heroku, along with the private and
   public key (remember, the key can *only* be used for ths specified port forwarding,
   not for shell access).
4. Enjoy
