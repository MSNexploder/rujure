module Rujure
  module Objects
    class Atom
      ATOM = Rujure.function :atom
      KEYWORD = Rujure.function :keyword

      attr_reader :atom

      def initialize(value, options=nil)
        if options.nil?
          @atom = ATOM.invoke(value)
        else
          @atom = ATOM.invoke(value, *transform_options(options))
        end
      end

      deref_function = Rujure.function('deref')
      define_method 'value' do |timeout=nil, timeout_val=nil|
        if timeout.nil?
          deref_function.invoke(atom)
        else
          deref_function.invoke(atom, (timeout * 1000.0), timeout_val)
        end
      end

      swap_function = Rujure.function('swap!')
      define_method 'swap!' do |*args, &block|
        swap_function.invoke(atom, ProcIFn.new(block), *args)
      end

      compare_and_set_function = Rujure.function('compare-and-set!')
      define_method 'compare_and_set!' do |oldval, newval|
        compare_and_set_function.invoke(atom, oldval, newval)
      end

      get_validator_function = Rujure.function('get-validator')
      define_method 'validator' do
        validator = get_validator_function.invoke(atom)
        validator.is_a?(ProcIFn) ? validator.proc : validator
      end

      set_validator_function = Rujure.function('set-validator!')
      define_method 'validator=' do |&block|
        set_validator_function.invoke(atom, ProcIFn.new(block))
      end

      add_watch_function = Rujure.function('add-watch')
      define_method 'add_observer' do |key, &block|
        add_watch_function.invoke(atom, key, ProcIFn.new(block))
      end

      remove_watch_function = Rujure.function('remove-watch')
      define_method 'remove_observer' do |key|
        remove_watch_function.invoke(atom, key)
      end

      private

      def transform_options(options)
        keys = options.keys.map { |k| KEYWORD.invoke(k.to_s) }
        values = options.values.map { |v| v.is_a?(::Proc) ? Rujure::ProcIFn.new(v) : v }
        keys.zip(values).flatten
      end
    end
  end
end
