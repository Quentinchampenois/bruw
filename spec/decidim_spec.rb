# frozen_string_literal: true

RSpec.describe Bruw::Decidim do
  let(:klass) { Bruw::Decidim }

  describe "#version" do
    it "raises an error" do
      expect { klass.version }.to raise_error(StandardError, /Not in Decidim project/)
    end

    context "when in decidim project" do
      before do
        allow(klass).to receive(:decidim_app?).and_return(true)
        allow(klass).to receive(:parse_gem_version).and_return("0.23.4")
      end

      it "returns the current decidim version" do
        expect(klass.version).not_to be nil
        expect(klass.version).to eq("0.23.4")
      end
    end
  end

  describe "#curl" do
    it "curl the target file on Decidim's official repository" do
      expect(false).to be_truthy
    end

    context "when selecting a specific version" do
      it "curl the target file from the specified version on Decidim's official repository" do
        expect(false).to be_truthy
      end
    end

    context "when file does not exists on Decidim's official repository" do
      it "raises an error" do
        expect(false).to be_truthy
      end
    end
  end
end
