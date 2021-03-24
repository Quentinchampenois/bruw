RSpec.describe Bruw do
  it "has a version number" do
    expect(Bruw::VERSION).not_to be nil
  end

  it "returns a specific version number" do
    expect(Bruw::Base.version).to eql("0.0.1")
  end
end
