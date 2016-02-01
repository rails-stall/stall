require 'rails_helper'

RSpec.describe Stall::Checkout::StepForm do
  describe '#validate' do
    it 'runs the validations for the current form' do
      form_class = Stall::Checkout::StepForm.build do
        validates :title, presence: true
      end

      book = build(:book, title: nil)
      form = form_class.new(book, double(:step))

      form.validate

      expect(form.target.errors.count).to eq(1)
    end

    it 'runs the validations for the nested forms' do
      form_class = Stall::Checkout::StepForm.build do
        nested :category do
          validates :name, presence: true
        end
      end

      category = build(:category, name: nil)
      book = build(:book, category: category)
      form = form_class.new(book, double(:step))

      form.validate

      expect(form.target.category.errors.count).to eq(1)
    end
  end

  describe '.nested' do
    it 'allows to add nested forms to validate to the form' do
      form_class = Stall::Checkout::StepForm.build
      form_class.nested(:category) { validates :title, presence: true }
      expect(form_class.nested_forms[:category]).to be_a(Class)
    end
  end

  describe '.build' do
    it 'returns an anonymous subclass of Stall::Checkout::StepForm' do
      form_class = Stall::Checkout::StepForm.build
      expect(form_class).to be_a(Class)
    end
  end

  describe '#method_missing' do
    it 'first delegates to the target if the target defines the method' do
      form_class = Stall::Checkout::StepForm.build
      book = build(:book)
      form = form_class.new(book, double(:step))
      expect(form.title).to eq(book.title)
    end

    it 'delegates to the target if the target defines the method' do
      form_class = Stall::Checkout::StepForm.build
      step = double(:step, important: true)
      form = form_class.new(build(:book), step)

      expect(step).to receive(:_validation_method_missing).with(:important).and_return(true)
      expect(form.important).to eq(true)
    end
  end
end
