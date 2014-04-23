module Rujure
  class ProcIFn
    include Java::ClojureLang::IFn
    include Java::JavaUtil::Comparator

    attr_reader :proc

    def initialize(proc)
      @proc = proc
    end

    def invoke(*args)
      proc.call *args
    end

    def compare(o1, o2)
      proc.call o1, o2
    end
  end
end
