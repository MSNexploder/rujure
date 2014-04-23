require File.expand_path('../test_helper', File.dirname(__FILE__))

describe Rujure do
  it "returns a clojure function" do
    sort = Rujure.function 'clojure.core', 'sort'
    refute_nil sort
    assert_equal [1, 2, 3], sort.invoke([3, 2, 1])
  end

  it "returns a clojure function from default namespace" do
    sort = Rujure.function 'sort'
    refute_nil sort
    assert_equal [1, 2, 3], sort.invoke([3, 2, 1])
  end

  it "returns a non-core clojure function" do
    refute_nil Rujure.function('clojure.set', 'join')
  end
end
