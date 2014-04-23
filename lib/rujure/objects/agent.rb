module Rujure
  module Objects
    class Agent
      AGENT = Rujure.function :agent
      KEYWORD = Rujure.function :keyword

      attr_reader :agent

      shutdown_agents_function = Rujure.function('shutdown-agents')
      define_singleton_method 'shutdown!' do
        shutdown_agents_function.invoke()
      end

      def initialize(state, options=nil)
        if options.nil?
          @agent = AGENT.invoke(state)
        else
          @agent = AGENT.invoke(state, *transform_options(options))
        end
      end

      deref_function = Rujure.function('deref')
      define_method 'state' do
        deref_function.invoke(agent)
      end

      agent_error_function = Rujure.function('agent-error')
      define_method 'error' do
        agent_error_function.invoke(agent)
      end

      %w(send send-off).each do |function_name|
        method_name = function_name.sub('send', 'post').gsub('-', '_')
        function = Rujure.function(function_name)
        define_method method_name do |*args, &block|
          function.invoke(agent, ProcIFn.new(block), *args)
        end
      end

      await_function = Rujure.function('await')
      define_method 'await' do
        await_function.invoke(agent)
      end

      await_for_function = Rujure.function('await-for')
      define_method 'await_for' do |timeout|
        await_for_function.invoke((timeout * 1000.0), agent)
      end

      get_validator_function = Rujure.function('get-validator')
      define_method 'validator' do
        validator = get_validator_function.invoke(agent)
        validator.is_a?(ProcIFn) ? validator.proc : validator
      end

      set_validator_function = Rujure.function('set-validator!')
      define_method 'validator=' do |&block|
        set_validator_function.invoke(agent, ProcIFn.new(block))
      end

      error_handler_function = Rujure.function('error-handler')
      define_method 'error_handler' do
        handler = error_handler_function.invoke(agent)
        handler.is_a?(ProcIFn) ? handler.proc : handler
      end

      set_error_handler_function = Rujure.function('set-error-handler!')
      define_method 'error_handler=' do |&block|
        set_error_handler_function.invoke(agent, ProcIFn.new(block))
      end

      error_mode_function = Rujure.function('error-mode')
      define_method 'error_mode' do
        mode = error_mode_function.invoke(agent)
        mode ? mode.to_s.to_sym : mode
      end

      set_error_mode_function = Rujure.function('set-error-mode!')
      define_method 'error_mode=' do |mode|
        set_error_mode_function.invoke(agent, KEYWORD.invoke(mode.to_s))
      end

      add_watch_function = Rujure.function('add-watch')
      define_method 'add_observer' do |key, &block|
        add_watch_function.invoke(agent, key, ProcIFn.new(block))
      end

      remove_watch_function = Rujure.function('remove-watch')
      define_method 'remove_observer' do |key|
        remove_watch_function.invoke(agent, key)
      end

      restart_agent_function = Rujure.function('restart-agent')
      define_method 'restart' do |state, options=nil|
        if options.nil?
          restart_agent_function.invoke(state)
        else
          restart_agent_function.invoke(state, *transform_options(options))
        end
      end

      at_exit {
        Rujure::Objects::Agent.shutdown!
      }

      private

      def transform_options(options)
        keys = options.keys.map { |k| KEYWORD.invoke(k.to_s) }
        values = options.values.map { |v| v.is_a?(::Proc) ? Rujure::ProcIFn.new(v) : v }
        keys.zip(values).flatten
      end
    end
  end
end
