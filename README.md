# Dort

List port used by container

## Installation

    $ gem install dort

## Usage

    $ dort

and help

    $ dort -h
    Usage: dort [options]
        -p, --port                       show publish ports only
        -e, --expose                     show expose ports only
        -l, --list                       list host port used by container

example

    $ dort -l
    HOST_PORTS
    80
    443
    3306
    5000
    5432
    6080
    6379
    8080
    8023
    10001
    10002
    10003
    10004
    10005

### Change socket
If you need to connect to other server or another location socket, you can set access point via DOCKER_URL variables. For example:

  DOCKER_URL=unix:///var/docker.sock dort
  DOCKER_URL=tcp://example.com:1000 dort

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/flum1025/dort. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dort project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dort/blob/master/CODE_OF_CONDUCT.md).
