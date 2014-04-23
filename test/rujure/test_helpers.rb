require File.expand_path('../test_helper', File.dirname(__FILE__))

describe Rujure::Helpers do
  module IncludeAll
    extend Rujure::Helpers
    include_clojure_namespace 'clojure.core'
  end

  module IncludeSome
    extend Rujure::Helpers
    include_clojure_namespace 'clojure.core', functions: %w(some string? swap! select-keys)
  end

  module IncludeWithAutoConversion
    extend Rujure::Helpers
    include_clojure_namespace 'clojure.core', auto_conversion: true
  end

  module IncludeWithoutAutoConversion
    extend Rujure::Helpers
    include_clojure_namespace 'clojure.core', auto_conversion: false
  end

  module IncludeMultiple
    extend Rujure::Helpers
    include_clojure_namespace 'clojure.core', functions: %w(some)
    include_clojure_namespace 'clojure.core', functions: %w(symbol), auto_conversion: false
  end

  it "includes all functions from a clojure namespace" do
    assert_respond_to IncludeAll, :some
    assert_respond_to IncludeAll, :list
  end

  it "includes predicate functions" do
    assert_respond_to IncludeAll, :string?
    assert_respond_to IncludeAll, :satisfies?
  end

  it "includes bang functions" do
    assert_respond_to IncludeAll, :swap!
    assert_respond_to IncludeAll, :alter_meta!
  end

  it "translates hypens into unterscores" do
    assert_respond_to IncludeAll, :select_keys
    assert_respond_to IncludeAll, :remove_watch
  end

  it "includes a subset functions from a clojure namespace" do
    assert_respond_to IncludeSome, :some
    refute_respond_to IncludeSome, :list
  end

  it "includes a subset of predicate functions" do
    assert_respond_to IncludeSome, :string?
    refute_respond_to IncludeSome, :satisfies?
  end

  it "includes a subset of bang functions" do
    assert_respond_to IncludeSome, :swap!
    refute_respond_to IncludeSome, :alter_meta!
  end

  it "translates hypens into unterscores for a subset of functions" do
    assert_respond_to IncludeSome, :select_keys
    refute_respond_to IncludeSome, :remove_watch
  end

  it "automatically converts procs" do
    proc = Proc.new { |x| x > 2 }
    assert IncludeWithAutoConversion.some(proc, [1, 2, 3])
  end

  it "automatically converts symbols" do
    assert_equal :foo, IncludeWithAutoConversion.symbol(:foo)
  end

  it "auto conversions defaults to true" do
    assert_equal :foo, IncludeAll.symbol(:foo)
  end

  it "does not convert procs if auto conversions is false" do
    proc = Proc.new { |x| x > 2 }
    assert_raises(Java::JavaLang::ClassCastException) {
      IncludeWithoutAutoConversion.some(proc, [1, 2, 3])
    }
  end

  it "does not convert symbols if auto conversions is false" do
    assert_raises(Java::JavaLang::ClassCastException) {
      IncludeWithoutAutoConversion.symbol(:foo)
    }
  end

  it "includes all methods from multiple calls" do
    assert_respond_to IncludeMultiple, :some
    assert_respond_to IncludeMultiple, :symbol
    refute_respond_to IncludeMultiple, :remove_watch
  end

  it "multiple includes honor conversion settings" do
    proc = Proc.new { |x| x > 2 }
    assert IncludeMultiple.some(proc, [1, 2, 3])
    assert_raises(Java::JavaLang::ClassCastException) {
      IncludeMultiple.symbol(:foo)
    }
  end
end
