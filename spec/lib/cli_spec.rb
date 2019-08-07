module Rubopop
  RSpec.describe CLI do
    context 'run!' do
      before do
        allow(EnvironmentChecker).to receive(:call)
        allow(Rubocop).to receive(:read_or_generate_todo)
          .and_return(SPEC_ROOT.join('fixtures', 'rubocop_todo.yml').read)
        allow(Git).to receive(:checkout)
        allow(Git).to receive(:commit_all)
        allow(File).to receive(:open)
      end

      it 'run each step with updated todo' do
        subject.run!
        expect(Git).to have_received(:checkout).exactly(3).times
        expect(Git).to have_received(:commit_all).exactly(2).times
        expect(File).to have_received(:open).exactly(3).times
      end
    end
  end
end
