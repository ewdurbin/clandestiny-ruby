require 'murmur3'
require 'string'
require 'digest/siphash'

module Clandestined
  class RendezvousHash

    include Murmur3

    attr_reader :nodes
    attr_reader :seed
    attr_reader :hash_function

    def initialize(nodes=nil, seed=0, hash_type=:murmur)
      @nodes = nodes || []
      @seed = seed

      case hash_type
      when :murmur
        @hash_function = lambda { |key| murmur3_32(key, seed) }
      when :siphash
        if seed == 0
          # siphash requires 128bit char
          seed = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        end

        @hash_function = lambda { |key|
          Digest::SipHash.digest(key, seed).reverse.hexencode.to_i(16)
        }
      end
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
      high_score = -1
      winner = nil
      nodes.each do |node|
        score = hash_function.call("#{node}-#{key}")
        if score > high_score
          high_score, winner = score, node
        elsif score == high_score
          high_score, winner = score, [node.to_s, winner.to_s].max
        end
      end
      winner
    end

  end
end
