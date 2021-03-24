# frozen_string_literal: true

RSpec.describe Bruw::Decidim do
  let(:klass) { Bruw::Decidim }

  describe '#version' do
    it 'raises an error' do
      expect { klass.version }.to raise_error(StandardError, /Not in Decidim project/)
    end

    context 'when in decidim project' do
      before do
        allow(klass).to receive(:decidim_app?).and_return(true)
        allow(klass).to receive(:parse_gem_version).and_return('0.23.4')
      end

      it 'returns the current decidim version' do
        expect(klass.version).not_to be nil
        expect(klass.version).to eq('0.23.4')
      end
    end
  end
end
