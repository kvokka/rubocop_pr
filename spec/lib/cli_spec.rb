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
        allow(Git).to receive(:push)
        allow(subject.repository).to receive(:create_pull_request)
        allow(subject.repository).to receive(:create_issue)
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

        it 'do not create issue' do
          expect(subject.repository).not_to have_received(:create_issue)
        end

        it 'do not create pull_request' do
          expect(subject.repository).not_to have_received(:create_pull_request)
        end

        it 'do not push any branches' do
          expect(Git).not_to have_received(:push)
        end
      end

      context 'lint both' do
        before do
          allow(Git).to receive(:status).and_return('path/to/changed/file')
          subject.run!
        end

        it 'one checkout on the start + 2 for todo file + 2 for lints + 2 times for the new branch' do
          expect(Git).to have_received(:checkout).exactly(7).times
        end

        it 'commit 2 rubocop todo updates + 2 lint updates' do
          expect(Git).to have_received(:commit_all).exactly(4).times
        end

        it 'update todo file' do
          expect(File).to have_received(:open).exactly(2).times
        end

        it 'create 2 issue' do
          expect(subject.repository).to have_received(:create_issue).exactly(2).times
        end

        it 'create 2 pull_request' do
          expect(subject.repository).to have_received(:create_pull_request).exactly(2).times
        end

        it 'pushed 2 branches' do
          expect(Git).to have_received(:push).exactly(2).times
        end
      end
    end
  end
end
