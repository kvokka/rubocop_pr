module Rubopop
  RSpec.describe Options do
    context 'parse' do
      subject { described_class.new([]).parse }

      it( "should be OpenStruct") { is_expected.to be_a OpenStruct }
    end

    context 'has default values for' do
      subject { described_class.new([]).parse.to_h }

      it( "hub_version"){ is_expected.to have_key :hub_version }
      it( "rubocop_todo_branch"){ is_expected.to have_key :rubocop_todo_branch }
      it( "post_checkout"){ is_expected.to have_key :post_checkout }
      it( "limit"){ is_expected.to have_key :limit }
      it( "debug"){ is_expected.to have_key :debug }
    end
  end
end
