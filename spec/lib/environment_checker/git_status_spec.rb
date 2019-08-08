# frozen_string_literal: true

module RubocopPr
  RSpec.describe EnvironmentChecker::GitStatus do
    subject { described_class.call }

    context 'with_changes' do
      before do
        allow(EnvironmentChecker::GitStatus).to receive(:git_status).and_return('something')
      end

      it('should not be ok') { expect { subject }.to raise_error RuntimeError }
    end

    context 'ok' do
      before do
        allow(described_class).to receive(:git_status).and_return('')
      end

      it('should be ok') { expect { subject }.not_to raise_error }
    end
  end
end
