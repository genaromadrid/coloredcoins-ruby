notification :terminal_notifier

rspec_options = {
  all_after_pass: true,
  cmd: 'rspec spec',
  failed_mode: :focus
}

guard :rspec, rspec_options do
  require 'ostruct'

  # Generic Ruby apps
  rspec = OpenStruct.new
  rspec.spec = ->(m) { "spec/#{m}_spec.rb" }
  rspec.spec_dir = 'spec'
  rspec.spec_helper = 'spec/spec_helper.rb'

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(rspec.spec_helper)      { rspec.spec_dir }
end
