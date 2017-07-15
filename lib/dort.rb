require "dort/version"
require 'json'
require 'docker'

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

      def to_s
        binds.map do |k,v|
          "#{v.join(",")}=>#{k}"
        end.join(", ")
      end

      def host
        binds.values
      end
    end

    class Expose
      attr_reader :ports
      def initialize(exposed_ports)
        @ports = exposed_ports.map{|port,_|port}
      end

      def to_s
        ports.join(", ")
      end
    end

    attr_reader :id, :name, :data, :ports, :expose

    def initialize(data)
      @data = data
      @id = @data['Id'][0..11]
      @name = @data['Name']
      @ports = Ports.new @data['HostConfig']['PortBindings'] || []
      @expose = Expose.new @data['Config']['ExposedPorts'] || []
    end

    def to_s
      "#<#{self.class}:#{object_id} Id=#{id} Name=#{name}>"
    end
    alias inspect to_s
  end

  module_function
  def containers
    Docker::Container.all(all: true).map do |container|
      Container.new(container.json)
    end
  end
end
