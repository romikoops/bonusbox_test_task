require 'spec_helper'

shared_examples_for "Instance variable based merger" do
  it "should execute InstanceVariableBasedMerger with correct arguments" do
    ivb_merger.should_receive(:merge).with(tag_text).once
    TagMergers::InstanceVariableBasedMerger.should_receive(:new).with(context){ ivb_merger }.once
    TagMergers::ClassBasedMerger.should_not_receive(:new)
    TagMergers::DefaultMerger.should_not_receive(:new)
    subject
  end
end

shared_examples_for "Default merger" do
  it "should execute DefaultMerger with correct arguments" do
    default_merger.should_receive(:merge).with(tag_text).once
    TagMergers::DefaultMerger.should_receive(:new).with(context){ default_merger }.once
    TagMergers::ClassBasedMerger.should_not_receive(:new)
    TagMergers::InstanceVariableBasedMerger.should_not_receive(:new)
    subject
  end
end

shared_examples_for "Class based merger" do
  it "should execute InstanceVariableBasedMerger with correct arguments" do
    cb_merger.should_receive(:merge).with(tag_text).once
    TagMergers::ClassBasedMerger.should_receive(:new).with(context){ cb_merger }.once
    TagMergers::InstanceVariableBasedMerger.should_not_receive(:new)
    TagMergers::DefaultMerger.should_not_receive(:new)
    subject
  end
end

describe TagMerger do
  describe "#execute" do
    subject { TagMerger.new(tag_text, context).execute}
    let(:context) { double }
    let(:ivb_merger) { double }
    let(:cb_merger) { double }
    let(:default_merger) { double }
    context "when tag == FOO:BAR" do
      let(:tag_text) { 'FOO:BAR' }
      context "when @foo present for context" do
        before { context.instance_variable_set(:@foo, 1) }
        it_behaves_like "Instance variable based merger"
      end
      context "when @foo absent for context" do
        it_behaves_like "Default merger"
      end
    end
    context "when tag == FOO:BAR:BAZ" do
      let(:tag_text) { 'FOO:BAR:BAZ' }
      context "when @foo present for context" do
        before { context.instance_variable_set(:@foo, 1) }
        it_behaves_like "Instance variable based merger"
      end
      context "when @foo absent for context" do
        it_behaves_like "Default merger"
      end
    end
    context "when tag == FOO" do
      let(:tag_text) { 'FOO' }
      it_behaves_like "Default merger"
    end
    context "when tag == FOO:[$key=value]" do
      let(:tag_text) { 'FOO:[$key=value]' }
      it_behaves_like "Class based merger"
    end
    context "when tag == FOO:[$key1=value1;$key2=value2]" do
      let(:tag_text) { 'FOO:[$key1=value1;$key2=value2]' }
      it_behaves_like "Class based merger"
    end
    context "when tag == FOO:BAR:[$key=value]" do
      let(:tag_text) { 'FOO:BAR:[$key=value]' }
      it_behaves_like "Class based merger"
    end
    context "when tag == FOO:BAR:BAZ:[$key=value]" do
      let(:tag_text) { 'FOO:BAR:BAZ:[$key=value]' }
      it_behaves_like "Class based merger"
    end
    context "when tag == FOO:BAR:[]" do
      let(:tag_text) { 'FOO:BAR:[]' }
      it_behaves_like "Class based merger"
    end
    context "when tag ==FOO:BAR[]" do
      let(:tag_text) { 'FOO:BAR[]' }
      it_behaves_like "Default merger"
    end
    context "when tag is blank" do
      let(:tag_text) { '' }
      it_behaves_like "Default merger"
    end
  end

end