require 'rails_helper'

RSpec.describe Manufacturer do
  it { should have_many(:products).dependent(:nullify) }
  it { should have_attached_file(:logo) }
  it { should validate_attachment_content_type(:logo).allowing('image/jpg', 'image/png').rejecting('text/plain', 'application/pdf') }
  it { should validate_presence_of(:name) }
end
