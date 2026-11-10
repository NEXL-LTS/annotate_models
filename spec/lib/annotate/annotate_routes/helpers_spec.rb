require_relative '../../../spec_helper'
require 'annotate/annotate_routes'

RSpec.describe AnnotateRoutes::Helpers do
  describe '.strip_annotations' do
    it 'removes the route annotation block and keeps the content after it' do
      content = "# == Route Map\n#\n# root GET / home#index\n\nRails.application.routes.draw do\nend\n"

      real_content, header_position = described_class.strip_annotations(content)

      expect(real_content).to eq(['Rails.application.routes.draw do', 'end', ''])
      expect(header_position).to eq(:before)
    end

    it 'handles a long whitespace-only line in the annotation block in linear time' do
      content = "# == Route Map\n#{' ' * 100_000}\nRails.application.routes.draw do\nend\n"

      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      real_content, = described_class.strip_annotations(content)
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

      expect(real_content).to eq(['Rails.application.routes.draw do', 'end', ''])
      expect(elapsed).to be < 1
    end
  end
end
