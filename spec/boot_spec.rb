require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'on boot' do
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end

  REQUIRED_ENVIRONMENT_KEYS.each do |var|
    it "raises error if TICKR_#{var} is not set" do
      lambda {
        ENV["TICKR_#{var}"] = nil
        suppress_warnings {load File.join(APPLICATION_ROOT, 'boot.rb')} # anticipate 'already initialized' warnings.
      }.should raise_error(RequiredSettingNotSetError)
    end
  end
end
