require 'digest/md5'
require 'digest/sha1'

class HashMaker
  # Hashes the given token with all available hash algorithms
  def self.hash_it(token)
    Hash[*hashers.map {|h| [h.name, h.hash_it(token)]}.flatten!]
  end

  private
  
  def self.hashers
    @@hashers ||= 
    Hashers.constants.map do |hasher|
      Hashers.const_get(hasher).new 
    end
  end
end

# Hashers go here.
# A hasher is expected to have two methods,
# #hash_it, which takes a token and returns a hash,
# and name, which returns the algorithm's name.
module Hashers
  # Convenience method for registering a hasher class
  def self.register_hasher(name, &block)
    hasher = Class.new
    hasher.send :define_method, :hash_it, &block
    hasher.send :define_method, :name, Proc.new { name }
    const_set name.capitalize + 'Hasher', hasher
  end    

  register_hasher("MD5") {|token| Digest::MD5.hexdigest(token) } 
  register_hasher("SHA1") {|token| Digest::SHA1.hexdigest(token) }
  register_hasher("SHA256") {|token| Digest::SHA256.hexdigest(token) }
  register_hasher("SHA384") {|token| Digest::SHA384.hexdigest(token) }
  register_hasher("SHA512") {|token| Digest::SHA512.hexdigest(token) }
end
