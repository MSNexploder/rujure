module Rujure
  module Helpers
    def include_clojure_namespace(namespace, options={})
      functions = options.fetch(:functions, nil)
      auto_conversion = options.fetch(:auto_conversion, true)

      Rujure.require(namespace)
      NSPUBLICS.invoke(SYMBOL.invoke(namespace.to_s)).each do |function_name, function|
        function_name = function_name.to_s
        next if functions && !functions.include?(function_name)
        method_name = function_name.gsub('-', '_')

        if auto_conversion
          define_method method_name do |*args|
            arguments = Rujure::Helpers.handle_arguments(args)
            value = function.invoke(*arguments)
            Rujure::Helpers.handle_return_value(value)
          end
        else
          define_method method_name do |*args|
            function.invoke(*args)
          end
        end
        module_function method_name
      end
    end

    def self.handle_arguments(arguments)
      arguments.map do |argument|
        case argument
        when ::Symbol then SYMBOL.invoke(argument.to_s)
        when ::Proc   then Rujure::ProcIFn.new(argument)
        else argument
        end
      end
    end

    def self.handle_return_value(value)
      case value
      when ::Java::ClojureLang::Symbol then value.to_s.to_sym
      when Rujure::ProcIFn             then value.proc
      else value
      end
    end

    private

    NSPUBLICS = Rujure.function 'ns-publics'
    SYMBOL = Rujure.function 'symbol'
  end
end
