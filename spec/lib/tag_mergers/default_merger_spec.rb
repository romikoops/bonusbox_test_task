require 'spec_helper'

describe TagMergers::DefaultMerger do
  describe "#merge" do
    let(:context) { double }
    let(:tag) { 'foo' }
    subject { TagMergers::DefaultMerger.new(context).merge(tag) }
    it { should == tag }
  end
end
