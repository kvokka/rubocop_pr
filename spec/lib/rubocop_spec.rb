module RubocopPr
  RSpec.describe Rubocop do
    before do
      allow(described_class).to receive(:generate_todo)
      allow(described_class).to receive(:correct!)
    end

    context 'todo' do
      context 'with todo file' do
        before do
          allow(subject).to receive(:read_or_generate_todo)
            .and_return(SPEC_ROOT.join('fixtures', 'rubocop_todo.yml').read)
        end

        it('return parsed todo file') { expect(subject.todo).to be_a Hash }
        it('have first cop')  { expect(subject.todo).to have_key 'Layout/Cop1' }
        it('have second cop') { expect(subject.todo).to have_key 'Layout/Cop2' }
      end

      context 'with out todo file' do
        subject { described_class.new git: Git.new }

        before do
          allow(File).to receive(:exist?)
          allow(File).to receive(:read).and_return('')
          allow(subject.git).to receive(:commit_all)
          allow(subject.git).to receive(:checkout)
        end

        it('generate todo file') do
          subject.todo
          expect(described_class).to have_received(:generate_todo)
          expect(subject.git).to have_received(:commit_all)
        end
      end
    end
  end
end
