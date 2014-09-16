require 'spec_helper'

describe Guard::ScssLint do
  let(:options) { { } }
  let(:plugin) { Guard::ScssLint.new(options) }

  context 'plugin' do
    it 'initializes' do
      expect(plugin).to_not be_nil
    end
  end
end
