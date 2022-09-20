# frozen_string_literal: true

RSpec.describe Annotable do
  let(:dummy_class) do
    Class.new do
      extend Annotable
    end
  end

  describe "::annotable" do
    context "when no name is given" do
      it "raises an ArgummentError" do
        expect { dummy_class.annotable }.to raise_error(ArgumentError)
      end
    end

    context "when a name is given" do
      it "defines the corresponding class method" do
        dummy_class.annotable(:hello)
        expect(dummy_class).to respond_to(:hello)
      end
    end

    describe "generated class method" do
      let(:annotation_name) { :hello }
      let(:params) { [:some_param] }
      let(:options) { { some: :option } }
      let(:annotation_double) { instance_double(Annotable::Annotation) }
      let(:current_annotations_double) { instance_double(Array) }

      before do
        allow(Annotable::Annotation).to receive(:new).and_return(annotation_double)
        allow(dummy_class).to receive(:current_annotations).and_return(current_annotations_double)
        allow(current_annotations_double).to receive(:push)

        dummy_class.annotable(annotation_name)
        dummy_class.send(annotation_name, *params, **options)
      end

      it "creates a new Annotation" do
        expect(Annotable::Annotation).to have_received(:new).with(annotation_name, params, options)
      end

      it "pushes the annotation into current_annotations array" do
        expect(current_annotations_double).to have_received(:push).with(annotation_double)
      end
    end
  end

  describe "::annotated_methods" do
    let(:method_double) { instance_double(Annotable::Method) }
    let(:annotation_exist?) { true }

    before do
      allow(method_double).to receive(:annotation_exist?).and_return(annotation_exist?)
      dummy_class.instance_variable_set(:@annotated_methods, [method_double])
    end

    context "when no name is given" do
      it "returns all annotated methods" do
        dummy_class.instance_variable_set(:@annotated_methods, [42])

        expect(dummy_class.annotated_methods).to eq([42])
      end
    end

    context "when an unknown name is given" do
      let(:annotation_exist?) { false }

      it "returns an empty array" do
        expect(dummy_class.annotated_methods(:some_name)).to eq([])
      end
    end

    context "when a known name is given" do
      it "returns an array containing matching methods" do
        expect(dummy_class.annotated_methods(:some_name)).to eq([method_double])
      end
    end
  end

  describe "::annotated_method_exist?" do
    let(:name) { :yes }

    before do
      method_double = instance_double(Annotable::Method)
      allow(method_double).to receive(:name).and_return(name)
      allow(dummy_class).to receive(:annotated_methods).and_return([method_double])
    end

    context "when annotation does not exist" do
      it "returns false" do
        expect(dummy_class.annotated_method_exist?(:no)).to be(false)
      end
    end

    context "when annotation exists" do
      it "returns true" do
        expect(dummy_class.annotated_method_exist?(name)).to be(true)
      end
    end
  end

  describe "::method_added" do
    let(:no_annotation?) { false }
    let(:annotatated_method_exist?) { false }
    let(:current_annotations_double) { instance_double(Array) }
    let(:method_double) { instance_double(Annotable::Method) }
    let(:method_name) { :my_anotated_method }

    before do
      allow(current_annotations_double).to receive(:empty?).and_return(no_annotation?)
      allow(dummy_class).to receive(:current_annotations).and_return(current_annotations_double)
      allow(dummy_class).to receive(:annotated_method_exist?).and_return(annotatated_method_exist?)
      allow(dummy_class).to receive(:remove_annotated_method)
      allow(dummy_class).to receive(:reset_current_annotations)
      allow(Annotable::Method).to receive(:new).and_return(method_double)

      dummy_class.instance_variable_set(:@annotated_methods, [])
      dummy_class.send(:method_added, method_name)
    end

    context "when there is no annotation" do
      let(:no_annotation?) { true }

      it "does not create a new method" do
        expect(Annotable::Method).not_to have_received(:new)
      end
    end

    context "when method is declared and annotated twice" do
      let(:annotatated_method_exist?) { true }

      it "replaces the annotated method" do
        expect(dummy_class).to have_received(:remove_annotated_method).with(method_name)
      end
    end

    context "when there is at least one annotation" do
      it "creates a new method with the annotations" do
        expect(Annotable::Method).to have_received(:new).with(method_name, current_annotations_double)
      end

      it "pushes the method in the array" do
        expect(dummy_class.instance_variable_get(:@annotated_methods)).to eq([method_double])
      end

      it "resests the current annotations array" do
        expect(dummy_class).to have_received(:reset_current_annotations)
      end
    end
  end

  describe "::remove_annotated_method" do
    let(:name) { :my_method_name }
    let(:method_double) { instance_double(Annotable::Method) }

    before do
      allow(method_double).to receive(:name).and_return(name)
      dummy_class.instance_variable_set(:@annotated_methods, [method_double])
    end

    it "removes the method from the array" do
      dummy_class.send(:remove_annotated_method, name)

      expect(dummy_class.instance_variable_get(:@annotated_methods)).to eq([])
    end

    it "don't change the array" do
      dummy_class.send(:remove_annotated_method, :no)

      expect(dummy_class.instance_variable_get(:@annotated_methods)).to eq([method_double])
    end
  end

  describe "::current_annotations" do
    it "sets the instance variable with an empty array" do
      dummy_class.send(:current_annotations)
      expect(dummy_class.instance_variable_get(:@current_annotations)).to eq([])
    end

    it "returns the instance variable" do
      dummy_class.instance_variable_set(:@current_annotations, 42)
      expect(dummy_class.send(:current_annotations)).to eq(42)
    end
  end

  describe "::reset_current_annotations" do
    it "resets the instance variable" do
      dummy_class.instance_variable_set(:@current_annotations, 42)
      dummy_class.send(:reset_current_annotations)

      expect(dummy_class.instance_variable_get(:@current_annotations)).to eq([])
    end
  end
end
