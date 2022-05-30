# frozen_string_literal: true

module Annotable
  #
  # An annotated method with its annotations.
  #
  #   one = Annotation.new(:one)
  #   two = Annotation.new(:two)
  #   some_method = Method.new(:some_method, one, two)
  #
  #   some_method.annotation_exist?(:one) # => true
  #   some_method.annotation_exist?(:no) # => false
  #   some_method.select_annotations(:one) # => [#<Annotable::Annotation @name=:one, @options={}, @params=[]>]
  #
  class Method
    # @return [Symbol] The method name
    attr_reader :name
    # @return [Array<Annotation>] The annotations declared for this method
    attr_reader :annotations

    #
    # Creates a new annotated method.
    #
    # @param [Symbol] name The method name
    # @param [Array<Annotation>] annotations The annotations linked to this method
    #
    def initialize(name, *annotations)
      raise ArgumentError, "You must provide at least one annotation" if annotations.empty?

      @name = name
      @annotations = annotations
    end

    #
    # Determines whether annotation exists based on its name.
    #
    # @param [Symbol] name The annotation's name to check for
    #
    # @return [Boolean] True if the annotation exists, false otherwise
    #
    def annotation_exist?(name)
      !annotations.find { |a| a.name == name }.nil?
    end

    #
    # Returns all annotations matching the given names.
    #
    # @param [Array<Symbol>] names Names of the annotations to select
    #
    # @return [Array<Annotation>] The matching annotations
    #
    def select_annotations(*names)
      raise ArgumentError, "You must provide at least one name to select" if names.empty?

      annotations.select do |a|
        names.include? a.name
      end
    end
  end
end
