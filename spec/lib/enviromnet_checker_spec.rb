# frozen_string_literal: true

module RubocopPr
  RSpec.describe EnvironmentChecker do
    let(:options) { OpenStruct.new }
    let(:repository) { Repository }
    subject { described_class.call repository, options }

    before do
      allow(EnvironmentChecker::GitStatus).to receive(:call)
    end

    context 'with out any repository' do
      it 'should run all checks' do
        subject
        expect(EnvironmentChecker::GitStatus).to have_received(:call)
      end
    end

    context 'with github repository' do
      let(:repository) { RubocopPr::Repository.all.fetch('github') }

      before do
        allow(Repositories::Github::Checks::VerifyHubVersion).to receive(:call)
      end

      it 'should run all checks' do
        subject
        expect(EnvironmentChecker::GitStatus).to have_received(:call)
        expect(Repositories::Github::Checks::VerifyHubVersion).to have_received(:call)
      end
    end
  end
end
