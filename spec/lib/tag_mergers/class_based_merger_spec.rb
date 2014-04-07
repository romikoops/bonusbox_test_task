require 'spec_helper'

describe TagMergers::ClassBasedMerger do
  let(:test_class) do
    Class.new do
      attr_reader :key, :key1, :key2
      def initialize(params)
        params.each {|k, v| instance_variable_set("@#{k}", v) }
      end
      def to_s
        [@key, @key1, @key2].compact.join(':').to_s
      end
    end
  end
  let(:test_module) { Module.new }
  let(:object_without_foo) do
    Object.send(:remove_const, :Foo) if Object.constants.include?("Foo".to_sym)
  end
  let(:object_with_foo_class) do
    object_without_foo
    Object.const_set("Foo", test_class)
  end
  let(:object_with_foo_module) do
    object_without_foo
    Object.const_set(:Foo, test_module)
  end
  let(:object_with_foo_bar) do
    object_with_foo_module
    Foo.const_set(:Bar, test_class)
  end
  let(:object_with_foo_bar_baz) do
    object_with_foo_module
    Foo.const_set(:Bar, test_module)
    Foo.const_set(:Baz, test_class)
  end
  describe "#merge" do
    let(:context) { double }
    let(:tag) { 'foo' }
    subject { TagMergers::ClassBasedMerger.new(context).merge(tag_text) }
    context "when tag == FOO:[$key=value]" do
      let(:tag_text) { 'FOO:[$key=value]' }
      context "when context has Foo class" do
        before { object_with_foo_class }
        its(:to_s) { should == 'value'}
      end
      context "when context has no Foo class" do
        before { object_without_foo }
        it { lambda{ subject }.should raise_error(NameError, 'uninitialized constant Foo') }
      end
    end
    context "when tag == FOO:[$key1=value1;$key2=value2]" do
      let(:tag_text) { 'FOO:[$key1=value1;$key2=value2]' }
      before { object_with_foo_class  }
      its(:to_s) { should == 'value1:value2'}
    end
    context "when tag == FOO:BAR:[$key=value]" do
      let(:tag_text) { 'FOO:BAR:[$key=value]' }
      before { object_with_foo_bar }
      its(:to_s) { should == 'value'}
    end
    context "when tag == FOO:BAR:[]" do
      let(:tag_text) { 'FOO:BAR:[]' }
      before { object_with_foo_bar }
      its(:to_s) { should == ''}
    end
    context "when tag == FOO:BAR:BAZ:[$key=value]" do
      let(:tag_text) { 'FOO:BAR:BAZ:[$key=value]' }
      before { object_with_foo_bar_baz }
      its(:to_s) { should == 'value'}
    end
  end
end