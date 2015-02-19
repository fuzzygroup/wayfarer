module Scrapespeare
  module Evaluator

    module_function

    # Evaluates a NodeSet to a concrete value (not `nil`)
    #
    # @param nodes [Nokogiri::XML::NodeSet]
    # @param attrs [Array<String>]
    # @return [String, Array<String>, Hash]
    def evaluate(nodes, *attrs)
      return "" if nodes.empty?

      if nodes.count == 1
        element = nodes.first

        case attrs.count
        when 0
          evaluate_content(element)
        when 1
          evaluate_attribute(element, attrs.first)
        else
          evaluate_attributes(element, *attrs)
        end
      else
        case attrs.count
        when 0
          nodes.map { |element| evaluate_content(element) }
        when 1
          nodes.map { |element| evaluate_attribute(element, attrs.first) }
        else
          nodes.map { |element| evaluate_attributes(element, *attrs) }
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
    def evaluate_attribute(element, attr)
      element.attr(attr).to_s
    end

    # Returns an element's attribute values
    #
    # @param element [Nokogiri::XML::Element]
    # @param attributes [Array<String>]
    # @return [Hash]
    def evaluate_attributes(element, *attrs)      
      attrs.reduce({}) do |hash, attr|
        hash.merge({ attr.to_sym => evaluate_attribute(element, attr) })
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
