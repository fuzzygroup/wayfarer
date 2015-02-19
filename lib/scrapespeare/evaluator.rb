module Scrapespeare
  module Evaluator

    RESERVED_ATTRIBUTES = [
      :content!,
      :html!
    ]

    module_function

    # Evaluates a NodeSet to a concrete value (not `nil`)
    #
    # @param nodes [Nokogiri::XML::NodeSet]
    # @param attrs [Array<Symbol>]
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

    # Returns an element's (sanitized) content
    #
    # @param element [Nokogiri::XML::Element]
    # @return [String]
    # @see .sanitize
    def evaluate_content(element)
      if Scrapespeare.config.sanitize_node_content
        sanitize(element.content)
      else
        element.content
      end
    end

    # Returns an element's attribute value
    #
    # @param element [Nokogiri::XML::Element]
    # @param attrs [Symbol]
    # @return [String]
    def evaluate_attribute(element, attr)
      if RESERVED_ATTRIBUTES.include?(attr)
        evaluate_reserved_attribute(element, attr)
      else
        element.attr(attr).to_s
      end
    end

    def evaluate_reserved_attribute(element, attr)
      case attr
      when :content! then evaluate_content(element)
      when :html! then element.to_s
      end
    end

    # Returns an element's attribute values
    #
    # @param element [Nokogiri::XML::Element]
    # @param attrs [Array<Symbol>]
    # @return [Hash]
    def evaluate_attributes(element, *attrs)      
      attrs.reduce({}) do |hash, attr|
        hash.merge({ attr => evaluate_attribute(element, attr) })
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
