module Rubopop
  RSpec.describe CLI do
    context 'run!' do
      before do
        allow(EnvironmentChecker).to receive(:call)
        allow(subject.rubocop).to receive(:autofix)
        allow(subject.rubocop).to receive(:read_or_generate_todo)
          .and_return(SPEC_ROOT.join('fixtures', 'rubocop_todo.yml').read)
        allow(Git).to receive(:checkout)
        allow(Git).to receive(:commit_all)
        allow(File).to receive(:open)
      end

      context 'no changes' do
        before do
          allow(Git).to receive(:status)
          subject.run!
        end

        it 'one checkout on the start + 2 for todo file' do
          expect(Git).to have_received(:checkout).exactly(3).times
        end

        it 'commit 2 rubocop todo updates' do
          expect(Git).to have_received(:commit_all).exactly(2).times
        end

        it 'update todo file' do
          expect(File).to have_received(:open).exactly(2).times
        end
      end

      context 'lint both' do
        before do
          allow(Git).to receive(:status).and_return('path/to/changed/file')
          subject.run!
        end

        it 'one checkout on the start + 2 for todo file + 2 for lints' do
          expect(Git).to have_received(:checkout).exactly(5).times
        end

        it 'commit 2 rubocop todo updates + 2 lint updates' do
          expect(Git).to have_received(:commit_all).exactly(4).times
        end

        it 'update todo file' do
          expect(File).to have_received(:open).exactly(2).times
        end
      end
    end
  end
end
