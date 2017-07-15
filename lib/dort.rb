#require "dort/version"
require 'systemu'
require 'json'
require 'docker' #TODO

module Dort
  class Container
    class Ports
      attr_reader :binds

      def initialize(port_bindings)
        @binds = Hash.new{|h,k|h[k] = []}
        port_bindings.each do |container_port, info|
          info.each do |host|
            @binds[container_port] << host['HostPort']
          end
        end
      end
    end

    class Expose
      attr_reader :ports
      def initialize(exposed_ports)
        @ports = exposed_ports.map{|port,_|port}
      end
    end

    attr_reader :data, :bind_ports, :expose

    def initialize(data)
      @data = data
      @bind_ports = Ports.new @data['HostConfig']['PortBindings']
      @expose = Expose.new @data['Config']['ExposedPorts']
    end

    def to_s
      "#<#{self.class}:#{object_id} Id=#{@data['Id'][0..11]} Name=#{@data['Name']}>"
    end
    alias inspect to_s
  end

  ExcutionError = Class.new(StandardError)
  module_function

  def containers
    #exec!('docker inspect $(docker ps -aq)')
    exec!("#{bin} inspect $(#{bin} ps -aq)")
  end

  def exec!(*args)
    status, stdout, stderr = systemu(*args)
    raise ExcutionError, stderr unless status.exitstatus.zero?
    info = JSON.parse(stdout)
    info.map{|d| Container.new(d)}
  end

  def bin
    ENV['DOCKER'] || `which docker`.chomp
  end
end

p Dort.containers.first.bind_ports
