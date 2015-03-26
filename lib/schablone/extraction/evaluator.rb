module Schablone
  module Extraction
    module Evaluator
      RESERVED_ATTRIBUTES = [
        :content!,
        :html!
      ]

      module_function

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

      def evaluate_content(element)
        if Schablone.config.sanitize_node_content
          sanitize(element.content)
        else
          element.content
        end
      end

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

      def evaluate_attributes(element, *attrs)
        attrs.reduce({}) do |hash, attr|
          hash.merge(attr => evaluate_attribute(element, attr))
        end
      end

      def sanitize(str)
        str.gsub("\n", "").strip
      end
    end
  end
end
