require 'murmur3'

module Clandestined
  class RendezvousHash

    include Murmur3

    attr_reader :nodes
    attr_reader :seed
    attr_reader :hash_function

    def initialize(nodes=nil, seed=0)
      @nodes = nodes || []
      @seed = seed

      @hash_function = lambda { |key| murmur3_32(key, seed) }
    end

    def add_node(node)
      @nodes.push(node) unless @nodes.include?(node)
    end

    def remove_node(node)
      if @nodes.include?(node)
        @nodes.delete(node)
      else
        raise ArgumentError, "No such node #{node} to remove"
      end
    end

    def find_node(key)
      find_nodes(key).first
    end

    def find_nodes(key, num_nodes=1)
      results = []
      nodes.each do |node|
        score = hash_function.call("#{node}-#{key}")
        results << [score, node]
      end
      # Sort descending by score, use the node id converted to string as tiebraker
      results.sort{|a,b| [b[0], b[1].to_s] <=> [a[0], a[1].to_s]}.take(num_nodes).map(&:last)
    end
  end
end
