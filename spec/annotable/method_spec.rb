# frozen_string_literal: true

RSpec.describe Annotable::Method do
  let(:annotation_names) { %i[one two] }
  let(:annotations) do
    [
      Annotable::Annotation.new(annotation_names.first),
      Annotable::Annotation.new(annotation_names.last)
    ]
  end
  let(:params) { [:my_method, *annotations] }
  let(:method) { described_class.new(*params) }

  describe "#initialize" do
    context "when only the name is given" do
      let(:params) { [:my_method] }

      it "raises an ArgumentError" do
        expect { method }.to raise_error(ArgumentError)
      end
    end

    context "when name and annotations are given" do
      it "sets the name of the annotated method" do
        expect(method.instance_variable_get(:@name)).to eq(params.first)
      end

      it "sets the annotations of the annotated method" do
        expect(method.instance_variable_get(:@annotations)).to eq(annotations)
      end
    end
  end

  describe "#annotation_exist?" do
    context "when the annotation doesn't exist" do
      it "returns false" do
        expect(method.annotation_exist?(:nope)).to be(false)
      end
    end

    context "when the annotation exist" do
      it "returns true" do
        expect(method.annotation_exist?(annotation_names.first)).to be(true)
      end
    end
  end

  describe "#select_annotations" do
    context "without param" do
      it "raises an ArgumentError" do
        expect { method.select_annotations }.to raise_error(ArgumentError)
      end
    end

    context "when the names exists" do
      it "returns the matching annotations" do
        expect(method.select_annotations(*annotation_names)).to eq(annotations)
      end
    end

    context "when the names doesn't exists" do
      it "returns an empty array" do
        expect(method.select_annotations(:nope)).to eq([])
      end
    end
  end

  describe "#find_annotation" do
    context "without param" do
      it "raises an ArgumentError" do
        expect { method.find_annotation }.to raise_error(ArgumentError)
      end
    end

    context "when the names exists" do
      it "returns the matching annotation" do
        expect(method.find_annotation(*annotation_names)).to eq(annotations.first)
      end
    end

    context "when the names doesn't exists" do
      it "returns an empty array" do
        expect(method.find_annotation(:nope)).to be_nil
      end
    end
  end
end
