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
        allow(klass).to receive(:current_version).and_return("0.24.3")
      end

      it "returns the current decidim version" do
        expect(klass.version).to eq("0.24.3")
      end
    end
  end

  describe "#curl" do
    let(:settings) { { owner: owner, repo: repo, version: version_tag, path: path } }

    let(:version_tag) { "0.23.4" }
    let(:owner) { "decidim" }
    let(:repo) { "decidim" }
    let(:path) { "decidim-core/app/forms/decidim/attachment_form.rb" }
    let(:branch) { nil }

    context "when everything is ok" do
      let(:version_tag) { "v0.23.4" }

      before do
        allow(klass).to receive(:curl_response).with(URI.parse("https://raw.githubusercontent.com/decidim/decidim/v0.23.4/decidim-core/app/forms/decidim/attachment_form.rb")).and_return("Content file from github repository")
      end

      it "curl the target file on Decidim's official repository" do
        expect(klass.curl(settings)).not_to be_empty
        expect(klass).to receive(:curl_response).with(URI.parse("https://raw.githubusercontent.com/decidim/decidim/v0.23.4/decidim-core/app/forms/decidim/attachment_form.rb"))
        expect(klass.curl(settings)).to eq("Content file from github repository")
      end
    end

    context "when file does not exists in github repository" do
      let(:owner) { "dummy" }
      let(:repo) { "repo" }
      let(:version_tag) { "v0.23.4" }
      let(:path) { "unknown/path/dummy_file.txt" }

      before do
        allow(klass).to receive(:curl_response).with(URI.parse("https://raw.githubusercontent.com/dummy/repo/v0.23.4/unknown/path/dummy_file.txt")).and_return(nil)
      end
      it "raises an error" do
        expect { klass.curl(settings) }.to raise_error StandardError
      end
    end
  end
end
