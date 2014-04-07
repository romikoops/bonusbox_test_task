require 'spec_helper'

describe TagMergers::InstanceVariableBasedMerger do
  describe "#merge" do
    let(:context) { double }
    let(:test_class_object) { double(bar: 'value2')}
    let(:test_object_with_instance_baz) { double(baz: 'value3') }
    let(:test_object_with_instance_bar) { double(bar: 'value1') }
    let(:test_object_with_bar_and_baz) { double(bar: test_object_with_instance_baz) }
    let(:test_object_with_class_bar) { double(class: test_class_object) }
    subject { TagMergers::InstanceVariableBasedMerger.new(context).merge(tag_name) }
    context "when tag == FOO:BAR" do
      let(:tag_name) { 'FOO:BAR' }
      context "when @foo object has #bar method" do
        before { context.instance_variable_set(:@foo, test_object_with_instance_bar) }
        it { should == 'value1' }
      end
      context "when @foo object has no #bar method" do
        context "when @foo object has .bar method" do
          before { context.instance_variable_set(:@foo, test_object_with_class_bar) }
          it { should == 'value2' }
        end
        context "when @foo object has no .bar method" do
          before { context.instance_variable_set(:@foo, double) }
          it { should == tag_name}
        end
      end
    end
    context "when tag == FOO:BAR:BAZ" do
      let(:tag_name) { 'FOO:BAR:BAZ' }
      before { context.instance_variable_set(:@foo, test_object_with_bar_and_baz) }
      it { should == 'value3' }
    end
  end
end