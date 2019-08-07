module Rubopop
  RSpec.describe CLI do
    context 'run!' do
      before do
        allow(EnvironmentChecker).to receive(:call)
        allow(subject.rubocop).to receive(:corrected?)
        allow(subject.rubocop).to receive(:read_or_generate_todo)
          .and_return(SPEC_ROOT.join('fixtures', 'rubocop_todo.yml').read)
        allow(subject.git).to receive(:exec_checkout).and_return(true)
        allow(subject.git).to receive(:commit_all)
        allow(subject.git).to receive(:push)
        allow(subject.repository).to receive(:create_pull_request)
        allow(subject.repository).to receive(:create_issue)
        allow(File).to receive(:open)
      end

      context 'no changes' do
        before do
          allow(subject.git).to receive(:status)
          subject.run!
        end

        it 'one checkout on the start&finish + 2 for todo file' do
          expect(subject.git).to have_received(:exec_checkout).exactly(4).times
        end

        it 'commit 2 rubocop todo updates' do
          expect(subject.git).to have_received(:commit_all).exactly(0).times
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
          expect(subject.git).not_to have_received(:push)
        end
      end

      context 'lint both' do
        before do
          allow(subject.git).to receive(:status).and_return('path/to/changed/file')
          subject.run!
        end

        it 'one checkout on the start&finish + 2 for todo file + 2 for lints + 2 times for the new branch' do
          expect(subject.git).to have_received(:exec_checkout).exactly(8).times
        end

        it 'commit 2 lint updates' do
          expect(subject.git).to have_received(:commit_all).exactly(2).times
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
          expect(subject.git).to have_received(:push).exactly(2).times
        end
      end

      context 'with big todo and low limit option' do
        before do
          allow(subject.rubocop).to receive(:read_or_generate_todo)
            .and_return(SPEC_ROOT.join('fixtures', 'big_todo.yml').read)
          allow(subject.git).to receive(:status).and_return('path/to/changed/file')
        end

        subject { described_class.new(['--limit', '5']) }

        it 'should create 5 pull requests' do
          subject.run!
          expect(subject.repository).to have_received(:create_pull_request).exactly(5).times
        end
      end

      context 'should run post checkout it is provided' do
        before do
          allow(subject.git).to receive(:status).and_return('path/to/changed/file')
          allow(subject.git).to receive(:exec_post_checkout)
        end

        subject { described_class.new(['--post-checkout', 'echo 42']) }

        it 'run post_checkout checkout on the start&finish + 2 for todo file + 2 for lints + 2 for the new branch' do
          subject.run!
          expect(subject.git).to have_received(:exec_post_checkout).exactly(8).times
        end
      end
    end
  end
end
