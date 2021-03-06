# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - Apache v2.0 License
# Encoding: utf-8

RSpec.configure do |config|
  config.before do |example|
    unless example.metadata[:clear]
      allow(Docker::Template::Ansi).to receive(:clear).and_return nil
    end
  end
end
