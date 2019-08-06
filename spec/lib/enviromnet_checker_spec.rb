# frozen_string_literal: true

module Rubopop
  RSpec.describe EnvironmentChecker do
    let(:options) { OpenStruct.new }
    subject { described_class.call options }

    before do
      allow(EnvironmentChecker::VerifyHubVersion).to receive(:call)
      allow(EnvironmentChecker::GitStatus).to receive(:call)
    end

    it 'should run all checks' do
      subject
      expect(EnvironmentChecker::VerifyHubVersion).to have_received(:call)
      expect(EnvironmentChecker::GitStatus).to have_received(:call)
    end
  end
end
