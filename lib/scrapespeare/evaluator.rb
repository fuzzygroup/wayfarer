module Scrapespeare
  module Evaluator

    extend self

    # Evaluates a NodeSet to a concrete value (not `nil`)
    #
    # @param nodes [Nokogiri::XML::NodeSet]
    # @param attributes [Array<String>]
    # @return [String, Array<String>, Hash]
    def evaluate(nodes, *attributes)
      return "" if nodes.empty?

      if nodes.count == 1
        element = nodes.first

        case attributes.count
        when 0
          evaluate_content(element)
        when 1
          evaluate_attribute(element, attributes.first)
        else
          evaluate_attributes(element, *attributes)
        end
      else
        case attributes.count
        when 0
          nodes.map { |element| evaluate_content(element) }
        when 1
          nodes.map { |element| evaluate_attribute(element, attributes.first) }
        else
          nodes.map { |element| evaluate_attributes(element, *attributes) }
        end
      end
    end

    # Returns an element's sanitized content
    #
    # @param element [Nokogiri::XML::Element]
    # @return [String]
    # @see .sanitize
    def evaluate_content(element)
      sanitize(element.content)
    end

    # Returns an element's attribute value
    #
    # @param element [Nokogiri::XML::Element]
    # @param attribute [String]
    # @return [String]
    def evaluate_attribute(element, attribute)
      element.attr(attribute).to_s
    end

    # Returns an element's attribute values
    #
    # @param element [Nokogiri::XML::Element]
    # @param attributes [Array<String>]
    # @return [Hash]
    def evaluate_attributes(element, *attributes)      
      attributes.reduce(Hash.new) do |hash, attribute|
        hash.merge({
          attribute.to_sym => evaluate_attribute(element, attribute)
        })
      end
    end

    # Removes line-breaks, leading and trailing white space from a String
    #
    # @param string [String]
    # @return [String]
    def sanitize(str)
      str.gsub("\n", "").strip
    end

  end
end
