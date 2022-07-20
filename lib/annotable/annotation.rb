# frozen_string_literal: true

module Annotable
  #
  # Encapsulates annotation data: name, params & options.
  #
  #   my_annotation = Annotation.new(:name, ["some", "params"], {some: "options"})
  #   my_annotation.name # => :name
  #   my_annotation.params # => ["some", "params"]
  #   my_annotation.options # => {some: "options"}
  #
  class Annotation
    # @return [Symbol] The annotation's name
    attr_reader :name
    # @return [Array<Object>] The annotation's params
    attr_reader :params
    # @return [Hash<Symbol, Object>] The annotation's options
    attr_reader :options

    #
    # Creates an new annotation.
    #
    # @param [Symbol] name The annotation's name
    # @param [Array<Object>] params The annotation's params
    # @param [Hash<Symbol, Object>] options The annotation's options
    #
    def initialize(name, params = [], options = {})
      @name = name
      @params = params
      @options = options
    end
  end
end
