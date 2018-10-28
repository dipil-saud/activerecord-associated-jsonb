# frozen_string_literal: true

# This class defines a Model that can be used with data in jsonb arrays
# It provides an AR like attributes api with validations
# Example Usage
#
# class User::Addresss < ActiveRecordAssociatedJsonb::Record
#   attribute :name
#   attribute :price, type: :float
#   attribute :filler, type: :boolean, default: false
#
#   validates :name, presence: true
# end
class ActiveRecordAssociatedJsonb::Record
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON
  include ActiveModel::Dirty

  # @return [Array<String>] Stores the list of attributes for the class
  def self.attributes_list
    @attributes_list ||= []
  end

  # Define an attribute for the class
  # Creates getters and setters
  #
  # @param attribute_name [Symbol]
  # @param options [Hash]
  #   * :default [String] Default value for the attribute
  #   * :type [Symbol] Type of attribute to cast to. Should be one of ActiveModel::Type
  def self.attribute(attribute_name, options = {})
    attributes_list << attribute_name
    define_attribute_method attribute_name # required by ActiveModel::Dirty

    define_attribute_getter(attribute_name, options)
    define_attribute_setter(attribute_name, options)
    define_attribute_checker(attribute_name)
  end

  # @returns [Hash] List of attributes and values for serialization
  def attributes
    self.class.attributes_list.each_with_object({}) do |property, attributes_hash|
      attributes_hash[property] = send(property)
      attributes_hash
    end
  end

  class << self
    # Defines the getter method for the attribute
    # Converts the value to specified type when returning
    def define_attribute_getter(attribute_name, options)
      define_method attribute_name do
        value = instance_variable_get("@#{attribute_name}")
        value = options[:default] if value.nil?

        if options[:type]
          value = ActiveModel::Type.lookup(options[:type]).cast(value)
        end

        value
      end
    end

    # Defines the setter method for the attribute
    def define_attribute_setter(attribute_name, options)
      define_method "#{attribute_name}=" do |value|
        send("#{attribute_name}_will_change!") unless value == send(attribute_name)

        if options[:type]
          value = ActiveModel::Type.lookup(options[:type]).deserialize(value)
        end

        instance_variable_set("@#{attribute_name}", value)
      end
    end

    # Defines the checker method which returns true if the attribute is set
    def define_attribute_checker(attribute_name)
      define_method "#{attribute_name}?" do
        send(attribute_name).present?
      end
    end
  end
end
