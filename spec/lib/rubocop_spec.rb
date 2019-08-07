module Rubopop
  RSpec.describe Rubocop do
    context 'todo' do
      subject { described_class.todo }

      context 'with todo file' do
        before do
          allow(described_class).to receive(:read_or_generate_todo)
            .and_return(SPEC_ROOT.join('fixtures', 'rubocop_todo.yml').read)
        end

        it('return parsed todo file') { is_expected.to be_a Hash }
        it('have first cop')  { is_expected.to have_key 'Layout/Cop1' }
        it('have second cop') { is_expected.to have_key 'Layout/Cop2' }
      end

      context 'with out todo file' do
        before do
          allow(described_class).to receive(:generate_todo)
          allow(File).to receive(:exist?)
          allow(File).to receive(:read).and_return('')
        end

        it('generate todo file') do
          subject
          expect(described_class).to have_received(:generate_todo)
        end
      end
    end
  end
end
