# frozen_string_literal: true

require_relative "annotable/annotation"
require_relative "annotable/method"
require_relative "annotable/version"

#
# Annotable is a module that can extend any class or module to add the ability to annotate its methods.
#
#   class Needy
#     extend Annotable # Extend your class or module with Annotable
#     annotable :my_annotation, :my_other_annotation # Declare your annotations
#
#     my_annotation 42, hello: "world!" # Annotate your methods
#     def method_needing_meta_data
#       # ...
#     end
#
#     def regular_method
#       # ...
#     end
#   end
#
# `Annotable` adds several methods to your class or module, providing access to annotations and their metadata:
#
#   Needy.annotated_method_exist? :method_needing_meta_data # => true
#   Needy.annotated_method_exist? :regular_method # => false
#   Needy.annotated_methods
#   # => [#<Annotable::Method
#   #   @annotations=[
#   #     #<Annotable::Annotation
#   #       @name=:my_annotation,
#   #       @options={:hello=>"world!"},
#   #       @params=[42]>
#   #   ],
#   #   @name=:method_needing_meta_data>
#   # ]
#
# `Annotable::Method` represents a method name along with its annotations:
#
#   method = Needy.annotated_methods.first
#   method.name # => :method_needing_meta_data
#   method.annotations
#   # => [
#   #   #<Annotable::Annotation
#   #     @name=:my_annotation,
#   #     @options={:hello=>"world!"},
#   #     @params=[42]>
#   # ]
#
# `Annotable::Annotation` contains annotation's name and metadata:
#
#   annotation = method.annotations.first
#   annotation.name # => :my_annotation
#   annotation.params # => [42]
#   annotation.options # => {:hello => "world!"}
#
module Annotable
  #
  # Declares annotations usable in the module or class.
  #
  #   annotable :my_annotation, :my_other_annotation
  #
  # This will generate two class methods named after the given symbols.
  # These methods, will push a new `Annotation` in the `current_annotation` array.
  #
  # @param [Array<Symbol>] annotation_names The names of annotations to declare
  #
  # @return [void]
  #
  def annotable(*annotation_names)
    raise ArgumentError, "You must provide at least one annotation name" if annotation_names.empty?

    annotation_names.each do |name|
      define_singleton_method(name) do |*params, **options|
        current_annotations.push Annotable::Annotation.new(name, params, options)
      end
    end
  end

  #
  # Return all annotated methods or those matching the given annotation names.
  #
  # @param [Array<Symbol>] names The annotation names to find
  #
  # @return [Array<Annotable::Method>] The annotated methods
  #
  def annotated_methods(*names)
    # Ractor.make_shareable(@annotated_methods)

    return @annotated_methods if @annotated_methods.empty? || names.empty?

    @annotated_methods.select do |method|
      annotation_found = false

      names.each do |name|
        annotation_found = method.annotation_exist?(name)
        break if annotation_found
      end

      annotation_found
    end
  end

  #
  # Check if an annotated method exists based in its name.
  #
  # @param [Symbol] name The name to check
  #
  # @return [Boolean] True if the annotated method exists, false otherwise
  #
  def annotated_method_exist?(name)
    # return false unless @annotated_methods

    !annotated_methods.find { |am| am.name == name }.nil?
  end

  private

  #
  # A callback called by Ruby when a method is added into the class or module.
  #
  # @param [Symbol] name The name of the created method
  #
  # @return [void]
  #
  def method_added(name)
    super
    @annotated_methods ||= []
    return if current_annotations.empty?

    remove_annotated_method(name) if annotated_method_exist?(name)
    @annotated_methods.push Annotable::Method.new(name, *current_annotations)

    reset_current_annotations
  end

  #
  # Remove an annotated method based on its name.
  #
  # @param [Symbol] name The name of the method to delete
  #
  # @return [void]
  #
  def remove_annotated_method(name)
    @annotated_methods.reject! do |annotated_method|
      annotated_method.name == name
    end
  end

  #
  # Annotation found for the current method declaration.
  #
  # @return [Array<Annotable::Annotation>] The annotations for the current method declaration
  #
  def current_annotations
    @current_annotations ||= []
  end

  #
  # Empty the current annotation array.
  #
  # @return [void]
  #
  def reset_current_annotations
    @current_annotations = []
  end
end
