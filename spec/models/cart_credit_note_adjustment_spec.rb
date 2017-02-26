require 'rails_helper'

RSpec.describe CartCreditNoteAdjustment do
  it_should_behave_like 'an adjustment'

  it { should have_one(:credit_note).dependent(:nullify) }
end
