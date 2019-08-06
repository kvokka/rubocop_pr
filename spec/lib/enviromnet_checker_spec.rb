# frozen_string_literal: true

module Rubopop
  RSpec.describe EnvironmentChecker do
    context 'VerifyHubVersion' do
      let(:options) { OpenStruct.new hub_version: '42.23.13' }
      subject { described_class.call options }

      context 'hub is not installed' do
        before do
          allow(EnvironmentChecker::VerifyHubVersion).to receive(:hub_version).and_return('')
        end

        it 'should raise if hub is not installed' do
          expect { subject }.to raise_error RuntimeError, %r{https://github.com/github/hub}
        end
      end

      context 'version' do
        before do
          allow(EnvironmentChecker::VerifyHubVersion).to receive(:hub_version).and_return("hub version #{hub_version}")
        end

        context 'lower than required' do
          let(:hub_version) { '1.1.1' }

          it('should warn about hub version') { expect { subject }.to output(Regexp.new(hub_version)).to_stderr }

          it('should not raise') { expect { subject }.not_to raise_error }
        end

        context 'greater than required' do
          let(:hub_version) { '111.1.1' }

          it('should not warn about hub version') { expect { subject }.to_not output.to_stderr }

          it('should not raise') { expect { subject }.not_to raise_error }
        end
      end
    end
  end
end
