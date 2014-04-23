require 'rujure/version'

# check if clojure is available
begin
  require 'java'
  ::Java::ClojureLang::Symbol
rescue NameError
  begin
    require 'clojure_jar'
  rescue LoadError => e
    raise unless e.message =~ /clojure_jar/
    message = 'No Clojure jar found in your Java Classpath. You can fix this by adding the `clojure_jar` gem to your Application Gemfile.'
    exception = e.exception(message)
    exception.set_backtrace(e.backtrace)
    raise exception
  end
end

module Rujure
  REQUIRE = ::Java::ClojureJavaApi::Clojure.var('clojure.core', 'require')
  SYMBOL = ::Java::ClojureJavaApi::Clojure.var('clojure.core', 'symbol')

  def self.function(namespace='clojure.core', name)
    require(namespace)
    ::Java::ClojureJavaApi::Clojure.var(namespace.to_s, name.to_s)
  end

  def self.read(name)
    ::Java::ClojureJavaApi::Clojure.read(name.to_s)
  end

  def self.require(namespace)
    namespace = namespace.to_s
    unless loaded_namespaces.include?(namespace)
      REQUIRE.invoke(SYMBOL.invoke(namespace))
      loaded_namespaces << namespace
    end
  end

  private

  def self.loaded_namespaces
    @loaded_namespaces ||= Set.new(['clojure.core']) # core is always loaded
  end
end

require 'rujure/proc_ifn'

require 'rujure/helpers'

# Don't force loading everything Clojure provides
Rujure.autoload :Core,          'rujure/core'
Rujure.autoload :Data,          'rujure/data'
Rujure.autoload :Edn,           'rujure/edn'
Rujure.autoload :Inspector,     'rujure/inspector'
Rujure.autoload :Instant,       'rujure/instant'
Rujure.autoload :Java,          'rujure/java'
Rujure.autoload :Main,          'rujure/main'
Rujure.autoload :PPrint,        'rujure/pprint'
Rujure.autoload :Reflect,       'rujure/reflect'
Rujure.autoload :Repl,          'rujure/repl'
Rujure.autoload :Set,           'rujure/set'
Rujure.autoload :Stracktrace,   'rujure/stacktrace'
Rujure.autoload :String,        'rujure/string'
Rujure.autoload :Template,      'rujure/template'
Rujure.autoload :Test,          'rujure/test'
Rujure.autoload :Walk,          'rujure/walk'
Rujure.autoload :XML,           'rujure/xml'
Rujure.autoload :Zip,           'rujure/zip'

require 'rujure/objects/agent'
require 'rujure/objects/atom'
