# frozen_string_literal: true

RSpec.describe Annotable::Annotation do
  let(:name) { :my_annotation }
  let(:params) { ["some_param"] }
  let(:options) { { some: "option" } }
  let(:annotation) { described_class.new(name, params, options) }

  describe "#initialize" do
    context "with name, params and options" do
      it "sets the name of the annotation" do
        expect(annotation.instance_variable_get(:@name)).to eq(name)
      end

      it "sets the params of the annotation" do
        expect(annotation.instance_variable_get(:@params)).to eq(params)
      end

      it "sets the options of the annotation" do
        expect(annotation.instance_variable_get(:@options)).to eq(options)
      end
    end

    context "with name only" do
      let(:annotation) { described_class.new(name) }

      it "sets params value to default" do
        expect(annotation.instance_variable_get(:@params)).to eq([])
      end

      it "sets options value to default" do
        expect(annotation.instance_variable_get(:@options)).to eq({})
      end
    end
  end
end
